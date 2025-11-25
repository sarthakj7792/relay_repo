import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:relay_repo/data/models/in_app_notification.dart';
import 'package:relay_repo/data/repositories/supabase_repository.dart';

class NotificationsViewModel extends AsyncNotifier<List<InAppNotification>> {
  late SupabaseRepository _repository;
  late Box _box;

  @override
  Future<List<InAppNotification>> build() async {
    _repository = ref.read(supabaseRepositoryProvider);
    _box = Hive.box('notifications');
    return _fetchNotifications();
  }

  Future<List<InAppNotification>> _fetchNotifications() async {
    final notifications = await _repository.getActiveNotifications();
    return notifications;
  }

  List<String> get _readIds {
    return List<String>.from(
        _box.get('read_ids', defaultValue: <String>[]) as List);
  }

  int get unreadCount {
    final notifications = state.value ?? [];
    final readIds = _readIds;
    return notifications.where((n) => !readIds.contains(n.id)).length;
  }

  bool isRead(String id) {
    return _readIds.contains(id);
  }

  Future<void> markAsRead(String id) async {
    final readIds = _readIds;
    if (!readIds.contains(id)) {
      readIds.add(id);
      await _box.put('read_ids', readIds);
      // Force state update to trigger UI rebuilds
      if (state.hasValue) {
        state = AsyncData(state.value!);
      }
    }
  }

  Future<void> markAllAsRead() async {
    final notifications = state.value ?? [];
    final readIds = _readIds;
    final newIds =
        notifications.map((n) => n.id).where((id) => !readIds.contains(id));

    if (newIds.isNotEmpty) {
      readIds.addAll(newIds);
      await _box.put('read_ids', readIds);
      if (state.hasValue) {
        state = AsyncData(state.value!);
      }
    }
  }
}

final notificationsViewModelProvider =
    AsyncNotifierProvider<NotificationsViewModel, List<InAppNotification>>(() {
  return NotificationsViewModel();
});
