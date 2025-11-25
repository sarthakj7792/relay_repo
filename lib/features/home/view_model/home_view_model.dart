import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/data/models/in_app_notification.dart';
import 'package:relay_repo/data/repositories/supabase_repository.dart';
import 'package:relay_repo/core/services/metadata_service.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends AsyncNotifier<List<SavedItem>> {
  late SupabaseRepository _repository;

  @override
  Future<List<SavedItem>> build() async {
    _repository = ref.watch(supabaseRepositoryProvider);
    return _repository.getItems();
  }

  Future<void> addItem(String url) async {
    try {
      final metadataService = ref.read(metadataServiceProvider);
      final metadata = await metadataService.fetchMetadata(url);

      final id = const Uuid().v4();
      final newItem = SavedItem(
        id: id,
        title: metadata?.title ?? 'New Video from $url',
        url: url,
        platform: _detectPlatform(url),
        date: DateTime.now(),
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
