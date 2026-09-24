import 'package:shared_preferences/shared_preferences.dart';

/// A wellness goal a user can pin to her profile.
enum WellnessGoal {
  hydration,
  stress,
  sleep,
  nutrition,
  mindfulness,
  skincare;

  String get label {
    switch (this) {
      case WellnessGoal.hydration:
        return 'Hydration';
      case WellnessGoal.stress:
        return 'Reduce stress';
      case WellnessGoal.sleep:
        return 'Better sleep';
      case WellnessGoal.nutrition:
        return 'Better nutrition';
      case WellnessGoal.mindfulness:
        return 'Mindfulness';
      case WellnessGoal.skincare:
        return 'Skin care';
    }
  }

  String get emoji {
    switch (this) {
      case WellnessGoal.hydration:
        return '💧';
      case WellnessGoal.stress:
        return '🧘';
      case WellnessGoal.sleep:
        return '🌙';
      case WellnessGoal.nutrition:
        return '🥗';
      case WellnessGoal.mindfulness:
        return '🧠';
      case WellnessGoal.skincare:
        return '✨';
    }
  }
}

class ProfileData {
  final String name;
  final String? avatarPath;
  final List<WellnessGoal> goals;

  const ProfileData({
    required this.name,
    required this.avatarPath,
    required this.goals,
  });
}

/// SharedPreferences-backed profile info: display name, a local avatar photo
/// path, and a short list of pinned wellness goals. Kept intentionally
/// simple (no backend) to match this app's local-only, private-by-default
/// approach to personal data.
class ProfilePrefs {
  static const _nameKey = 'profile_name';
  static const _avatarPathKey = 'profile_avatar_path';
  static const _goalsKey = 'profile_goals';

  static const List<WellnessGoal> defaultGoals = [
    WellnessGoal.hydration,
    WellnessGoal.stress,
    WellnessGoal.sleep,
  ];

  static Future<ProfileData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey) ?? 'there';
    final avatarPath = prefs.getString(_avatarPathKey);
    final rawGoals = prefs.getStringList(_goalsKey);
    final goals = rawGoals == null
        ? defaultGoals
        : rawGoals
            .map((name) => WellnessGoal.values
                .where((g) => g.name == name)
                .cast<WellnessGoal?>()
                .firstOrNull)
            .whereType<WellnessGoal>()
            .toSet()
            .toList();
    return ProfileData(name: name, avatarPath: avatarPath, goals: goals);
  }

  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  static Future<void> saveAvatarPath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove(_avatarPathKey);
    } else {
      await prefs.setString(_avatarPathKey, path);
    }
  }

  static Future<void> saveGoals(List<WellnessGoal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_goalsKey, goals.map((g) => g.name).toList());
  }
}
