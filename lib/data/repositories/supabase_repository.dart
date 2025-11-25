import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/features/folders/models/folder.dart';

class SupabaseRepository {
  final SupabaseClient _client;

  SupabaseRepository(this._client);

  Future<List<SavedItem>> getItems() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('saved_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => SavedItem.fromJson(e)).toList();
  }

  Future<void> addItem(SavedItem item) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final itemWithUser = item.copyWith(
      userId: userId,
      createdAt: DateTime.now(),
    );

    await _client.from('saved_items').insert(itemWithUser.toJson());
  }

  Future<void> deleteItem(String id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _client
        .from('saved_items')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  Future<void> toggleBookmark(String id, bool isBookmarked) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _client
        .from('saved_items')
        .update({'is_bookmarked': isBookmarked})
        .eq('id', id)
        .eq('user_id', userId);
  }

  // Folders
  Future<List<Folder>> getFolders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('folders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((data) {
      return Folder(
        id: data['id'],
        title: data['title'],
        videoCount: 0, // Placeholder
        thumbnailPath: null, // Placeholder
      );
    }).toList();
  }

  Future<void> createFolder(String title) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('folders').insert({
      'title': title,
      'user_id': userId,
    });
  }

  Future<void> deleteFolder(String id) async {
    await _client.from('folders').delete().eq('id', id);
  }
}

final supabaseRepositoryProvider = Provider<SupabaseRepository>((ref) {
  return SupabaseRepository(Supabase.instance.client);
});
