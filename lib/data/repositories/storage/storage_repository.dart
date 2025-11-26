import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/data/models/in_app_notification.dart';

abstract class StorageRepository {
  Future<List<SavedItem>> getItems({String? folderId});
  Future<void> addItem(SavedItem item);
  Future<void> deleteItem(String id);
  Future<void> toggleBookmark(String id, bool isBookmarked);
  Future<void> moveItemToFolder(String itemId, String? folderId);

  // Folders
  Future<List<Folder>> getFolders();
  Future<void> createFolder(String title);
  Future<void> renameFolder(String id, String newTitle);
  Future<void> deleteFolder(String id);

  Future<List<InAppNotification>> getActiveNotifications();
}
