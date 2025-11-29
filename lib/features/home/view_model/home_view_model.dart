import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/data/models/in_app_notification.dart';
import 'package:relay_repo/data/repositories/storage/storage_provider.dart';
import 'package:relay_repo/data/repositories/storage/storage_repository.dart';
import 'package:relay_repo/core/services/metadata_service.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends AsyncNotifier<List<SavedItem>> {
  late StorageRepository _repository;

  @override
  Future<List<SavedItem>> build() async {
    _repository = ref.watch(storageRepositoryProvider);
    return _repository.getItems();
  }

  Future<void> addItem(String url) async {
    try {
      // Check for duplicates
      final currentList = state.asData?.value ?? [];
      final normalizedUrl = _normalizeUrl(url);
      final exists =
          currentList.any((item) => _normalizeUrl(item.url) == normalizedUrl);
      if (exists) {
        log('Item with URL $url already exists. Skipping.');
        return;
      }

      final metadataService = ref.read(metadataServiceProvider);
      final metadata = await metadataService.fetchMetadata(url);

      final id = const Uuid().v4();
      final newItem = SavedItem(
        id: id,
        title: metadata?.title ?? 'New Video from $url',
        url: url,
        platform: _detectPlatform(url),
        date: DateTime.now().toUtc(),
        thumbnailPath: metadata?.image,
        description: metadata?.description,
      );

      await _repository.addItem(newItem);
      ref.invalidateSelf();
    } catch (e) {
      // Error adding item
      log('Error adding item: $e');
    }
  }

  // ... (existing methods)

  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
    ref.invalidateSelf();
  }

  Future<List<Folder>> getFolders() async {
    return await _repository.getFolders();
  }

  Future<void> createFolder(String title) async {
    await _repository.createFolder(title);
  }

  Future<void> toggleBookmark(String id) async {
    // We need to know the current state to toggle it.
    // Ideally the UI passes the new state or we fetch it.
    // For now, let's assume we toggle based on the current list in state.
    final currentList = state.asData?.value;
    if (currentList != null) {
      final item = currentList.firstWhere((element) => element.id == id);
      await _repository.toggleBookmark(id, !item.isBookmarked);
      ref.invalidateSelf();
    }
  }

  Future<void> moveItemToFolder(String itemId, String? folderId) async {
    await _repository.moveItemToFolder(itemId, folderId);
    ref.invalidateSelf();
  }

  Future<void> deleteFolder(String id) async {
    await _repository.deleteFolder(id);
    // We might need to refresh folders list.
    // Since folders are fetched via a Future in the UI (ref.watch(homeViewModelProvider.notifier).getFolders()),
    // we might need a way to invalidate that if it was a provider.
    // But currently getFolders is just a future method.
    // The UI calls setState or re-builds to refresh.
    // Ideally, folders should be a separate provider.
    // For now, we'll rely on the UI to refresh.
  }

  Future<void> renameFolder(String id, String newTitle) async {
    await _repository.renameFolder(id, newTitle);
  }

  Future<List<InAppNotification>> getActiveNotifications() async {
    return await _repository.getActiveNotifications();
  }

  Future<void> updateNotes(String id, String notes) async {
    try {
      await _repository.updateNotes(id, notes);
      // Update local state
      final currentItems = state.value ?? [];
      final index = currentItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = currentItems[index].copyWith(notes: notes);
        final updatedItems = List<SavedItem>.from(currentItems);
        updatedItems[index] = updatedItem;
        state = AsyncValue.data(updatedItems);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateWatchProgress(String id, Duration watchedDuration,
      Duration totalDuration, bool isWatched) async {
    try {
      await _repository.updateWatchProgress(
          id, watchedDuration, totalDuration, isWatched);

      // Update local state
      final currentItems = state.value ?? [];
      final index = currentItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = currentItems[index].copyWith(
          watchedDuration: watchedDuration,
          duration: totalDuration,
          isWatched: isWatched,
          watchedAt: isWatched ? DateTime.now() : currentItems[index].watchedAt,
        );
        final updatedItems = List<SavedItem>.from(currentItems);
        updatedItems[index] = updatedItem;
        state = AsyncValue.data(updatedItems);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> shareFolder(String folderId, String email) async {
    try {
      await _repository.shareFolder(folderId, email);
      // We might want to show a success message or update the folder state if we had the updated list
    } catch (e) {
      // Handle error
    }
  }

  String _normalizeUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Handle YouTube
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        String? videoId;
        if (uri.host.contains('youtu.be')) {
          videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        } else if (uri.path.contains('shorts')) {
          videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
        } else {
          videoId = uri.queryParameters['v'];
        }

        if (videoId != null) {
          return 'https://www.youtube.com/watch?v=$videoId';
        }
      }

      // Handle Instagram
      if (uri.host.contains('instagram.com')) {
        // Remove query parameters
        return '${uri.scheme}://${uri.host}${uri.path}';
      }

      // Default: remove trailing slash and query params if needed, but for now just basic normalization
      // Let's just return the URL without query params for most platforms to be safe against tracking params
      // But some platforms need query params (like YouTube, handled above).

      // For generic URLs, let's just strip tracking params if possible, or just return as is if we are unsure.
      // A safe bet for now is to just return the full URL if not handled above,
      // or maybe just scheme + host + path.

      // Let's stick to scheme + host + path for everything else to avoid ?utm_source=...
      return '${uri.scheme}://${uri.host}${uri.path}';
    } catch (e) {
      return url;
    }
  }

  String _detectPlatform(String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return 'YouTube';
    }
    if (url.contains('instagram.com')) {
      return 'Instagram';
    }
    if (url.contains('twitter.com') || url.contains('x.com')) {
      return 'X (Twitter)';
    }
    if (url.contains('tiktok.com')) {
      return 'TikTok';
    }
    if (url.contains('reddit.com') || url.contains('redd.it')) {
      return 'Reddit';
    }
    if (url.contains('quora.com')) {
      return 'Quora';
    }
    if (url.contains('linkedin.com')) {
      return 'LinkedIn';
    }
    return 'Web';
  }
}

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, List<SavedItem>>(() {
  return HomeViewModel();
});
