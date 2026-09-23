import '../entities/gamification_profile.dart';

abstract class GamificationRepostiory {
  Future <GamificationProfile> getProfile();
  Future<void> saveProfile(GamificationProfile profile);
}