import 'package:flutter/material.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/core/utils/date_utils.dart';

class SavedItemCard extends StatelessWidget {
  final SavedItem item;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onDelete;
  final VoidCallback? onAddToFolder;

  const SavedItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onBookmark,
    required this.onDelete,
    this.onAddToFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Theme.of(context).brightness == Brightness.light
          ? AppTheme.glassCardDecoration
          : AppTheme.glassCardDecorationDark,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      image: item.thumbnailPath != null
                          ? DecorationImage(
                              image: NetworkImage(item.thumbnailPath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey[800],
                    ),
                    child: item.thumbnailPath == null
                        ? const Center(
                            child: Icon(Icons.video_library,
                                color: Colors.white54, size: 40))
                        : null,
                  ),
                  // Play Icon Overlay
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 24),
                    ),
                  ),
                  // Platform Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.platform,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.timeAgo(item.date),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show options
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          margin: const EdgeInsets.all(16),
                          decoration:
                              Theme.of(context).brightness == Brightness.light
                                  ? AppTheme.glassCardDecoration
                                  : AppTheme.glassCardDecorationDark,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  item.isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  item.isBookmarked ? 'Unbookmark' : 'Bookmark',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  onBookmark();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.folder_open,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                title: Text('Add to Folder',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (onAddToFolder != null) {
                                    onAddToFolder!();
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                title: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  Navigator.pop(context);
                                  onDelete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.more_vert,
                        size: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
