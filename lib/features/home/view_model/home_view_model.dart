import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/data/repositories/supabase_repository.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends AsyncNotifier<List<SavedItem>> {
  late final SupabaseRepository _repository;

  @override
  Future<List<SavedItem>> build() async {
    _repository = ref.watch(supabaseRepositoryProvider);
    return _repository.getItems();
  }

  Future<void> addItem(String url) async {
    try {
      // Mock metadata fetching
      final id = const Uuid().v4();
      final newItem = SavedItem(
        id: id,
        title: 'New Video from $url',
        url: url,
        platform: _detectPlatform(url),
        date: DateTime.now(),
        thumbnailPath: null, // Placeholder
      );

      await _repository.addItem(newItem);
      ref.invalidateSelf();
    } catch (e) {
      // Error adding item
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
    return 'Web';
  }
}

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, List<SavedItem>>(() {
  return HomeViewModel();
});
