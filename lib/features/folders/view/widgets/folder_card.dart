import 'package:flutter/material.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/core/theme/app_theme.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: Theme.of(context).brightness == Brightness.light
            ? AppTheme.glassCardDecoration
            : AppTheme.glassCardDecorationDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon/Thumbnail Collage
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildThumbnail(context),
            ),
            const SizedBox(height: 16),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                folder.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            // Count
            Text(
              '${folder.videoCount} videos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (folder.previewImages.isEmpty) {
      return Center(
        child: Icon(Icons.folder_rounded,
            color: Theme.of(context).primaryColor, size: 32),
      );
    }

    if (folder.previewImages.length == 1) {
      return Image.network(
        folder.previewImages.first,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // 2x2 Grid
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  folder.previewImages[0],
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: folder.previewImages.length > 1
                    ? Image.network(
                        folder.previewImages[1],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: folder.previewImages.length > 2
                    ? Image.network(
                        folder.previewImages[2],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1)),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: folder.previewImages.length > 3
                    ? Image.network(
                        folder.previewImages[3],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
