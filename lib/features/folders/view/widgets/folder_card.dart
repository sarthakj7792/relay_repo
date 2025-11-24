import 'package:flutter/material.dart';
import 'package:relay_repo/features/folders/models/folder.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon/Thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                image: folder.thumbnailPath != null
                    ? DecorationImage(
                        image: NetworkImage(folder.thumbnailPath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: folder.thumbnailPath == null
                  ? Icon(Icons.folder_rounded,
                      color: Theme.of(context).primaryColor, size: 32)
                  : null,
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              folder.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Count
            Text(
              '${folder.videoCount} videos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
