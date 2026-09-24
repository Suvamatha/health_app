import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/profile/profile_prefs.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../features/gamification/presentation/cubit/gamification_state.dart';
import '../../features/hydration/presentation/cubit/hydration_cubit.dart';
import '../../features/hydration/presentation/cubit/hydration_state.dart';
import '../../features/period/domain/cycle_insights.dart';
import '../../features/period/presentation/cubit/period_cubit.dart';
import '../../features/period/presentation/cubit/period_state.dart';
import '../../widgets/dashboard_card.dart';
import 'widgets/edit_profile_sheet.dart';

/// The profile hub: an editable photo + name up top, quick-glance cycle and
/// wellness-goal cards, a few feel-good stats, and a menu into every other
/// area of the app. Reachable by tapping the avatar in the dashboard's top
/// right corner.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData _profile = const ProfileData(name: 'there', avatarPath: null, goals: ProfilePrefs.defaultGoals);
  bool _loaded = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfilePrefs.load();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loaded = true;
    });
  }

  Future<void> _openEditSheet() async {
    final saved = await showEditProfileSheet(context, current: _profile);
    if (saved == true) _loadProfile();
  }

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: AnimatedOpacity(
          opacity: _loaded ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: theme.colorScheme.surface,
                    backgroundImage: (_profile.avatarPath != null && File(_profile.avatarPath!).existsSync())
                        ? FileImage(File(_profile.avatarPath!))
                        : null,
                    child: (_profile.avatarPath != null && File(_profile.avatarPath!).existsSync())
                        ? null
                        : Text('🌸', style: const TextStyle(fontSize: 36)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text('Hi, ${_profile.name}!', style: theme.textTheme.displayLarge)),
              const SizedBox(height: 4),
              Center(
                child: Text('Your wellness journey', style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _openEditSheet,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(height: 28),
              BlocBuilder<PeriodCubit, PeriodState>(
                builder: (context, state) {
                  final prediction = CycleInsights.predict(state.entries);
                  return DashboardCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text('🤍', style: const TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('My Cycle', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 2),
                              Text(
                                prediction.predictedNextStart != null
                                    ? 'Next period: ${_formatDate(prediction.predictedNextStart!)}'
                                    : 'Start tracking to see predictions',
                                style: theme.textTheme.bodyMedium,
                              ),
                              if (prediction.predictedNextStart != null)
                                Text(
                                  '${prediction.averageCycleLength.round()} day average',
                                  style: theme.textTheme.bodyMedium,
                                ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/cycle'),
                          child: const Text('View →'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text('🌿', style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('My Wellness Goals', style: theme.textTheme.titleMedium)),
                              TextButton(onPressed: _openEditSheet, child: const Text('Edit →')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (_profile.goals.isEmpty)
                            Text('Add a goal to see it here.', style: theme.textTheme.bodyMedium)
                          else
                            ..._profile.goals.map(
                              (goal) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('${goal.emoji}  ${goal.label}', style: theme.textTheme.bodyLarge),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(child: Text('Your Journey ✨', style: theme.textTheme.headlineSmall)),
              const SizedBox(height: 16),
              BlocBuilder<GamificationCubit, GamificationState>(
                builder: (context, gState) {
                  final streak = gState.profile?.currentStreak ?? 0;
                  return BlocBuilder<HydrationCubit, HydrationState>(
                    builder: (context, hState) {
                      return BlocBuilder<PeriodCubit, PeriodState>(
                        builder: (context, pState) {
                          final cycles = CycleInsights.predict(pState.entries).loggedCycleCount;
                          return Row(
                            children: [
                              Expanded(
                                child: _JourneyStat(
                                  emoji: '🌱',
                                  value: '$streak',
                                  label: 'Day streak',
                                ),
                              ),
                              Expanded(
                                child: _JourneyStat(
                                  emoji: '💧',
                                  value: '${hState.glassesLoggedToday}/${hState.dailyGoal}',
                                  label: 'Today',
                                ),
                              ),
                              Expanded(
                                child: _JourneyStat(
                                  emoji: '🌸',
                                  value: '$cycles',
                                  label: 'Cycles',
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 28),
              Divider(color: theme.colorScheme.outline),
              const SizedBox(height: 12),
              DashboardCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuRow(
                      emoji: '😊',
                      title: 'Mood & Wellness',
                      onTap: () => context.go('/insights'),
                    ),
                    Divider(height: 1, color: theme.colorScheme.outline),
                    _MenuRow(
                      emoji: '🔔',
                      title: 'Notifications',
                      onTap: () => context.push('/notifications'),
                    ),
                    Divider(height: 1, color: theme.colorScheme.outline),
                    _MenuRow(
                      emoji: '🎨',
                      title: 'Appearance',
                      onTap: () => context.push('/appearance'),
                    ),
                    Divider(height: 1, color: theme.colorScheme.outline),
                    _MenuRow(
                      emoji: '🔒',
                      title: 'Privacy & Security',
                      onTap: () => context.push('/privacy'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DashboardCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  leading: Icon(Icons.spa_outlined, color: theme.colorScheme.primary),
                  title: Text('Wellspring', style: theme.textTheme.bodyLarge),
                  trailing: Text('v1.3.0', style: theme.textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _JourneyStat({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(value, style: theme.textTheme.titleMedium),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const _MenuRow({required this.emoji, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      leading: Text(emoji, style: const TextStyle(fontSize: 18)),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
      onTap: onTap,
    );
  }
}
