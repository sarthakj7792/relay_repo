import 'package:hive_flutter/hive_flutter.dart';
import 'package:relay_repo/core/utils/logger.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/data/repositories/storage/storage_repository.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/data/models/in_app_notification.dart';
import 'package:uuid/uuid.dart';

class LocalStorageRepository implements StorageRepository {
  static const String itemsBoxName = 'saved_items';
  static const String foldersBoxName = 'folders';

  Future<Box<SavedItem>> get _itemsBox async {
    if (!Hive.isBoxOpen(itemsBoxName)) {
      return await Hive.openBox<SavedItem>(itemsBoxName);
    }
    return Hive.box<SavedItem>(itemsBoxName);
  }

  Future<Box<Folder>> get _foldersBox async {
    if (!Hive.isBoxOpen(foldersBoxName)) {
      return await Hive.openBox<Folder>(foldersBoxName);
    }
    return Hive.box<Folder>(foldersBoxName);
  }

  @override
  Future<List<SavedItem>> getItems({String? folderId}) async {
    final box = await _itemsBox;
    var items = box.values.toList();
    if (folderId != null) {
      items = items.where((item) => item.folderId == folderId).toList();
    }
    // Sort by date descending
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  @override
  Future<void> addItem(SavedItem item) async {
    final box = await _itemsBox;
    await box.put(item.id, item);
  }

  @override
  Future<void> deleteItem(String id) async {
    final box = await _itemsBox;
    await box.delete(id);
  }

  @override
  Future<void> toggleBookmark(String id, bool isBookmarked) async {
    final box = await _itemsBox;
    final item = box.get(id);
    if (item != null) {
      final updatedItem = item.copyWith(isBookmarked: isBookmarked);
      await box.put(id, updatedItem);
    }
  }

  @override
  Future<void> moveItemToFolder(String itemId, String? folderId) async {
    final box = await _itemsBox;
    final item = box.get(itemId);
    if (item != null) {
      // copyWith doesn't support setting null if the argument is optional and defaults to null check
      // We need to manually construct if we want to set to null, or update copyWith.
      // For now, let's assume copyWith works or we reconstruct.
      // Actually, looking at SavedItem.dart: folderId: folderId ?? this.folderId
      // So passing null keeps the old value.
      // We need to reconstruct.
      final updatedItem = SavedItem(
        id: item.id,
        title: item.title,
        url: item.url,
        platform: item.platform,
        thumbnailPath: item.thumbnailPath,
        date: item.date,
        isBookmarked: item.isBookmarked,
        aiSummary: item.aiSummary,
        userId: item.userId,
        createdAt: item.createdAt,
        description: item.description,
        folderId: folderId, // This sets the new value (null or string)
      );
      await box.put(itemId, updatedItem);
    }
  }

  // Folders

  @override
  Future<List<Folder>> getFolders() async {
    final box = await _foldersBox;
    return box.values.toList();
  }

  @override
  Future<void> createFolder(String title) async {
    final box = await _foldersBox;
    final id = const Uuid().v4();
    final folder = Folder(
      id: id,
      title: title,
      iconPath: 'assets/icons/folder.png',
      createdAt: DateTime.now(),
      videoCount: 0,
    );
    await box.put(id, folder);
  }

  @override
  Future<void> renameFolder(String id, String newTitle) async {
    final box = await _foldersBox;
    final folder = box.get(id);
    if (folder != null) {
      final newFolder = Folder(
        id: folder.id,
        title: newTitle,
        videoCount: folder.videoCount,
        thumbnailPath: folder.thumbnailPath,
        previewImages: folder.previewImages,
        iconPath: folder.iconPath,
        createdAt: folder.createdAt,
      );
      await box.put(id, newFolder);
    }
  }

  @override
  Future<void> deleteFolder(String id) async {
    final foldersBox = await _foldersBox;
    await foldersBox.delete(id);

    // Update items to remove folderId
    final itemsBox = await _itemsBox;
    final items = itemsBox.values.where((item) => item.folderId == id).toList();
    for (final item in items) {
      final updatedItem = SavedItem(
        id: item.id,
        title: item.title,
        url: item.url,
        platform: item.platform,
        thumbnailPath: item.thumbnailPath,
        date: item.date,
        isBookmarked: item.isBookmarked,
        aiSummary: item.aiSummary,
        userId: item.userId,
        createdAt: item.createdAt,
        description: item.description,
        folderId: null, // Explicitly null
      );
      await itemsBox.put(item.id, updatedItem);
    }
  }

  @override
  Future<List<InAppNotification>> getActiveNotifications() async {
    return [];
  }

  @override
  Future<void> updateNotes(String id, String notes) async {
    final box = await _itemsBox;
    final item = box.values.firstWhere((item) => item.id == id);
    final index = box.values.toList().indexOf(item);

    final updatedItem = item.copyWith(notes: notes);
    await box.putAt(index, updatedItem);
  }

  @override
  Future<void> updateWatchProgress(String id, Duration watchedDuration,
      Duration totalDuration, bool isWatched) async {
    final box = await _itemsBox;
    try {
      final item = box.values.firstWhere((item) => item.id == id);
      final index = box.values.toList().indexOf(item);

      final updatedItem = item.copyWith(
        watchedDuration: watchedDuration,
        duration: totalDuration,
        isWatched: isWatched,
        watchedAt: isWatched ? DateTime.now() : item.watchedAt,
      );
      await box.putAt(index, updatedItem);
    } catch (e) {
      // Item not found or error updating
      Logger.logger('Error updating watch progress locally: $e');
    }
  }

  @override
  Future<void> shareFolder(String folderId, String email) async {
    // Local storage doesn't support real sharing, but we can simulate it or just log it.
    Logger.logger(
        'Sharing folder $folderId with $email (Local Storage - Simulated)');
    // In a real local-only app, maybe we'd just add to a list of "pending shares" to sync later.
  }
}
