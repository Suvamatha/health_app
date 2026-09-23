// lib/features/gamification/domain/rank.dart

/// Fantasy/adventure-themed rank tiers, derived purely from totalXp.
/// Never stored — always calculated fresh from GamificationProfile.totalXp.
enum Rank {
  wanderer(minXp: 0, label: 'Wanderer'),
  seeker(minXp: 50, label: 'Seeker'),
  voyager(minXp: 150, label: 'Voyager'),
  vanguard(minXp: 300, label: 'Vanguard'),
  luminary(minXp: 500, label: 'Luminary');

  final int minXp;
  final String label;
  const Rank({required this.minXp, required this.label});

  static Rank fromXp(int xp) {
    Rank current = Rank.wanderer;
    for (final rank in Rank.values) {
      if (xp >= rank.minXp) current = rank;
    }
    return current;
  }
}