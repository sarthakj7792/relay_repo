import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/features/folders/view/widgets/folder_card.dart';
import 'package:relay_repo/features/home/view_model/home_view_model.dart';
import 'package:relay_repo/features/folders/view/folder_detail_screen.dart';
import 'package:relay_repo/core/theme/app_theme.dart';

class FoldersScreen extends ConsumerStatefulWidget {
  const FoldersScreen({super.key});

  @override
  ConsumerState<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends ConsumerState<FoldersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E2B5F).withValues(alpha: 0.5),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.folder_outlined,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'My Collections',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.search,
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final foldersAsync =
                        ref.watch(homeViewModelProvider.notifier).getFolders();
                    final itemsAsync = ref.watch(homeViewModelProvider);

                    return FutureBuilder<List<Folder>>(
                      future: foldersAsync,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final folders = List<Folder>.from(snapshot.data ?? []);
                        final items = itemsAsync.asData?.value ?? [];

                        // Update folder counts and thumbnails
                        for (var i = 0; i < folders.length; i++) {
                          final folderItems = items
                              .where((item) => item.folderId == folders[i].id)
                              .toList();

                          folders[i] = Folder(
                            id: folders[i].id,
                            title: folders[i].title,
                            videoCount: folderItems.length,
                            thumbnailPath: folderItems.isNotEmpty
                                ? folderItems.first.thumbnailPath
                                : null,
                            previewImages: folderItems
                                .map((e) => e.thumbnailPath)
                                .where((e) => e != null)
                                .take(4)
                                .cast<String>()
                                .toList(),
                          );
                        }

                        // Add Bookmarks folder
                        final bookmarkCount =
                            items.where((i) => i.isBookmarked).length;
                        final lastBookmarked =
                            items.where((i) => i.isBookmarked).firstOrNull;

                        folders.insert(
                            0,
                            Folder(
                              id: 'bookmarks',
                              title: 'Bookmarks',
                              videoCount: bookmarkCount,
                              thumbnailPath: lastBookmarked?.thumbnailPath,
                              previewImages: items
                                  .where((i) => i.isBookmarked)
                                  .map((e) => e.thumbnailPath)
                                  .where((e) => e != null)
                                  .take(4)
                                  .cast<String>()
                                  .toList(),
                            ));

                        if (folders.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.2)),
                                const SizedBox(height: 16),
                                Text(
                                  'No folders yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            return FolderCard(
                              folder: folders[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FolderDetailScreen(
                                      folder: folders[index],
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                if (folders[index].id != 'bookmarks') {
                                  _showFolderOptions(
                                      context, ref, folders[index]);
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5DD3), Color(0xFF3F8CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5DD3).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'folders_fab',
          onPressed: () => _showCreateFolderDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showFolderOptions(BuildContext context, WidgetRef ref, Folder folder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: Theme.of(context).brightness == Brightness.light
            ? AppTheme.glassCardDecoration
            : AppTheme.glassCardDecorationDark,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
              title: Text('Rename',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context, ref, folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, ref, folder);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Folder folder) {
    final controller = TextEditingController(text: folder.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Folder Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref
                    .read(homeViewModelProvider.notifier)
                    .renameFolder(folder.id, controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {}); // Refresh list
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text('Are you sure you want to delete "${folder.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(homeViewModelProvider.notifier)
                  .deleteFolder(folder.id);
              setState(() {}); // Refresh list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Folder Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref
                    .read(homeViewModelProvider.notifier)
                    .createFolder(controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {}); // Refresh list
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
