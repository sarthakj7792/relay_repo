import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/data/models/saved_item.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

class ProgressService {
  ProgressService();

  double calculateKnowledgeProgress(List<SavedItem> items) {
    if (items.isEmpty) return 0.0;

    final watchedCount = items.where((item) => item.isWatched).length;
    return watchedCount / items.length;
  }

  Duration calculateTotalWatchedDuration(List<SavedItem> items) {
    return items.fold(Duration.zero, (total, item) {
      return total + (item.watchedDuration ?? Duration.zero);
    });
  }

  String getLevelTitle(double progress) {
    if (progress < 0.2) return 'Novice';
    if (progress < 0.5) return 'Learner';
    if (progress < 0.8) return 'Expert';
    return 'Master';
  }
}
