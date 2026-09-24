import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the user has already finished (or skipped) onboarding,
/// so the splash screen only shows it once — not on every app launch.
class OnboardingPrefs {
  static const _key = 'has_completed_onboarding';

  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
