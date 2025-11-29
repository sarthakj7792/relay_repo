import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relay_repo/core/utils/logger.dart';

final achievementsServiceProvider = Provider<AchievementsService>((ref) {
  return AchievementsService();
});

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    this.isUnlocked = false,
  });

  Achievement copyWith({bool? isUnlocked}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      iconPath: iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class AchievementsService {
  static const String _lastWeekKey = 'last_week_check';
  static const String _itemsWatchedThisWeekKey = 'items_watched_this_week';
  static const String _unlockedBadgesKey = 'unlocked_badges';

  late SharedPreferences _prefs;

  final List<Achievement> _allAchievements = [
    Achievement(
      id: 'curator',
      title: 'Curator',
      description: 'Watch 3 items in a week',
      iconPath: 'assets/badges/curator.png',
    ),
    Achievement(
      id: 'explorer',
      title: 'Explorer',
      description: 'Save items from 3 different platforms',
      iconPath: 'assets/badges/explorer.png',
    ),
    Achievement(
      id: 'scholar',
      title: 'Scholar',
      description: 'Watch 10 hours of content',
      iconPath: 'assets/badges/scholar.png',
    ),
  ];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<Achievement> getAchievements() {
    final unlockedIds = _prefs.getStringList(_unlockedBadgesKey) ?? [];
    return _allAchievements.map((achievement) {
      return achievement.copyWith(
        isUnlocked: unlockedIds.contains(achievement.id),
      );
    }).toList();
  }

  Future<void> incrementWeeklyProgress() async {
    final now = DateTime.now();
    final currentWeek = _getWeekNumber(now);
    final lastWeek = _prefs.getInt(_lastWeekKey) ?? 0;

    int itemsWatched = _prefs.getInt(_itemsWatchedThisWeekKey) ?? 0;

    if (currentWeek != lastWeek) {
      // New week, reset progress
      itemsWatched = 0;
      await _prefs.setInt(_lastWeekKey, currentWeek);
    }

    itemsWatched++;
    await _prefs.setInt(_itemsWatchedThisWeekKey, itemsWatched);

    if (itemsWatched >= 3) {
      await _unlockBadge('curator');
    }
  }

  Future<void> _unlockBadge(String badgeId) async {
    final unlockedIds = _prefs.getStringList(_unlockedBadgesKey) ?? [];
    if (!unlockedIds.contains(badgeId)) {
      unlockedIds.add(badgeId);
      await _prefs.setStringList(_unlockedBadgesKey, unlockedIds);
      Logger.logger('Badge unlocked: $badgeId');
    }
  }

  int _getWeekNumber(DateTime date) {
    final dayOfYear = int.parse(
        '${date.year}${date.difference(DateTime(date.year, 1, 1)).inDays}');
    return (dayOfYear / 7).ceil();
  }

  int get weeklyProgress => _prefs.getInt(_itemsWatchedThisWeekKey) ?? 0;
}
