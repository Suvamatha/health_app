import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/profile/profile_prefs.dart';

/// Reads the saved profile itself (name + photo) so every screen that
/// shows this header always reflects the latest edits made from the
/// Profile screen, without the dashboard having to know the details.
class GreetingHeader extends StatefulWidget {
  const GreetingHeader({super.key});

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader> {
  String _name = 'there';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfilePrefs.load();
    if (!mounted) return;
    setState(() {
      _name = profile.name;
      _avatarPath = profile.avatarPath;
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String get _today {
    final now = DateTime.now();
    return '${_months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _today,
                style: theme.textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text('$_greeting,', style: theme.textTheme.bodyMedium),
              Text(_name, style: theme.textTheme.displayLarge),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/profile').then((_) => _loadProfile()),
          child: Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.surface,
              backgroundImage: (_avatarPath != null && File(_avatarPath!).existsSync())
                  ? FileImage(File(_avatarPath!))
                  : null,
              child: (_avatarPath != null && File(_avatarPath!).existsSync())
                  ? null
                  : Icon(Icons.person_outline, color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
