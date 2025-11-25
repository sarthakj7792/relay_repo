import 'package:flutter/material.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final SavedItem item;

  const VideoDetailScreen({super.key, required this.item});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  bool _isLiked = false;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // For now, we assume the URL is a direct video link or we can't play it directly.
    // If it's a YouTube link, we would need youtube_player_flutter.
    // For this implementation, we'll try to play it if it looks like a video file,
    // otherwise we might show a "Open in Browser" button or similar.

    // Simple check for demo purposes
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player Area (Immersive)
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
                        color: Colors.grey[900],
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

                  // Back Button (only if controls are not visible? Chewie handles this mostly, but we might want a custom one)
                  // For now, let's keep the back button if player is NOT initialized or just overlay it.
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Platform
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
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      AppTheme.primaryColor.withValues(alpha: 0.5)),
                            ),
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
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
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
                            color: _isLiked ? Colors.red : Colors.white,
                            onTap: () => setState(() => _isLiked = !_isLiked),
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.share_outlined,
                            label: 'Share',
                            onTap: () {},
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.open_in_browser,
                            label: 'Open',
                            onTap: () {
                              // Open in browser
                            },
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.bookmark_border,
                            label: 'Save',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Description / Notes
                      if (widget.item.description != null) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.item.description!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Text(
                        'Notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: const Text(
                          'Add your personal notes about this video here...',
                          style: TextStyle(color: Colors.white54),
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
      Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
