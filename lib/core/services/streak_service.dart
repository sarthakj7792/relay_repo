import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relay_repo/core/providers/shared_preferences_provider.dart';

class StreakService {
  final SharedPreferences _prefs;
  static const String _lastVisitKey = 'last_visit_date';
  static const String _streakCountKey = 'streak_count';

  StreakService(this._prefs);

  int get currentStreak => _prefs.getInt(_streakCountKey) ?? 0;

  Future<void> checkStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastVisitString = _prefs.getString(_lastVisitKey);

    if (lastVisitString == null) {
      // First visit ever
      await _updateStreak(today, 1);
      return;
    }

    final lastVisit = DateTime.parse(lastVisitString);
    final lastVisitDate =
        DateTime(lastVisit.year, lastVisit.month, lastVisit.day);

    if (today.isAtSameMomentAs(lastVisitDate)) {
      // Already visited today, do nothing
      return;
    }

    final difference = today.difference(lastVisitDate).inDays;

    if (difference == 1) {
      // Consecutive day, increment streak
      await _updateStreak(today, currentStreak + 1);
    } else {
      // Streak broken, reset to 1
      await _updateStreak(today, 1);
    }
  }

  Future<void> _updateStreak(DateTime date, int count) async {
    await _prefs.setString(_lastVisitKey, date.toIso8601String());
    await _prefs.setInt(_streakCountKey, count);
  }
}

final streakServiceProvider = Provider<StreakService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StreakService(prefs);
});
