import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:relay_repo/data/models/saved_item.dart';

class SavedItemsRepository {
  final Box<SavedItem> _box;

  SavedItemsRepository(this._box);

  List<SavedItem> getAllItems() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addItem(SavedItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleBookmark(String id) async {
    final item = _box.get(id);
    if (item != null) {
      final updatedItem = item.copyWith(isBookmarked: !item.isBookmarked);
      await _box.put(id, updatedItem);
    }
  }
}

final savedItemsRepositoryProvider = Provider<SavedItemsRepository>((ref) {
  final box = Hive.box<SavedItem>('saved_items');
  return SavedItemsRepository(box);
});
