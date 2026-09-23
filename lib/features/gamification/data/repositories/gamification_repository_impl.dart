import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/gamification_profile.dart';
import '../../domain/repositories/gamification_repostiory.dart';

class GamificationRepositoryImpl implements GamificationRepostiory{
  static const _key = 'gamification_profile';

  @override 
  Future<GamificationProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if( raw == null) return const GamificationProfile();
    return GamificationProfile.fromJson(jsonDecode(raw));
  }

  @override
  Future <void> saveProfile(GamificationProfile profile) async {
    final prefs= await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }
}