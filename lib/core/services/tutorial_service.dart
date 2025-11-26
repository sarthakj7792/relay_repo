import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:relay_repo/core/providers/shared_preferences_provider.dart';

class TutorialService {
  final SharedPreferences _prefs;
  static const String _tutorialSeenKey = 'has_seen_tutorial';

  TutorialService(this._prefs);

  bool get hasSeenTutorial => _prefs.getBool(_tutorialSeenKey) ?? false;

  Future<void> markTutorialAsSeen() async {
    await _prefs.setBool(_tutorialSeenKey, true);
  }

  void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    Function()? onFinish,
    Function()? onSkip,
  }) {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: 'SKIP',
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        markTutorialAsSeen();
        onFinish?.call();
      },
      onClickTarget: (target) {
        // Continue to next target
      },
      onSkip: () {
        markTutorialAsSeen();
        onSkip?.call();
        return true;
      },
      onClickOverlay: (target) {
        // Continue to next target
      },
    ).show(context: context);
  }
}

final tutorialServiceProvider = Provider<TutorialService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TutorialService(prefs);
});
