import 'package:flutter/material.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/features/home/view_model/home_view_model.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  final SavedItem item;

  const VideoDetailScreen({super.key, required this.item});

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  bool _isLiked = false;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.item.isBookmarked;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // ... (existing code)
    if (widget.item.url.endsWith('.mp4') ||
        widget.item.url.contains('storage.googleapis.com')) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.item.url));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isPlayerInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _showMoveToFolderDialog() async {
    final folders = await ref.read(homeViewModelProvider.notifier).getFolders();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Folder'),
        content: SizedBox(
          width: double.maxFinite,
          child: folders.isEmpty
              ? const Text('No folders created yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(folder.title),
                      onTap: () {
                        ref
                            .read(homeViewModelProvider.notifier)
                            .moveItemToFolder(widget.item.id, folder.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to ${folder.title}'),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player Area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (_isPlayerInitialized && _chewieController != null)
                    Chewie(controller: _chewieController!)
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black, // Keep player background black
                        image: widget.item.thumbnailPath != null
                            ? DecorationImage(
                                image: NetworkImage(widget.item.thumbnailPath!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.item.thumbnailPath == null
                          ? const Center(
                              child: Icon(Icons.video_library,
                                  color: Colors.white24, size: 64))
                          : null,
                    ),
                  if (!_isPlayerInitialized)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.liquidBackgroundGradient
                      : AppTheme.liquidBackgroundGradientDark,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.glassChipDecoration
                                    : AppTheme.glassChipDecorationDark,
                            child: Text(
                              widget.item.platform,
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Added on ${widget.item.date.toString().split(' ')[0]}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                            fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            context,
                            icon: _isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: 'Like',
                            color: _isLiked
                                ? Colors.red
                                : Theme.of(context).colorScheme.onSurface,
                            onTap: () {
                              setState(() => _isLiked = !_isLiked);
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .toggleBookmark(widget.item.id);
                            },
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.share_outlined,
                            label: 'Share',
                            onTap: () {
                              // ignore: deprecated_member_use
                              Share.share(widget.item.url);
                            },
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.open_in_browser,
                            label: 'Open',
                            onTap: () async {
                              try {
                                final uri = Uri.parse(widget.item.url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  // Try launching anyway as a fallback
                                  await launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Could not open link: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.folder_open,
                            label: 'Folder',
                            onTap: _showMoveToFolderDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Description / Notes
                      if (widget.item.description != null) ...[
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.item.description!,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 24),
                      ],

                      Text(
                        'Notes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration:
                            Theme.of(context).brightness == Brightness.light
                                ? AppTheme.glassCardDecoration
                                : AppTheme.glassCardDecorationDark,
                        child: Text(
                          'Add your personal notes about this video here...',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? color}) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: effectiveColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}
