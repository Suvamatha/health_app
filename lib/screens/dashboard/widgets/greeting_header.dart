import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GreetingHeader extends StatelessWidget {
  final String name;

  const GreetingHeader({
    required this.name,
    super.key,
  });

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
              Text(name, style: theme.textTheme.displayLarge),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            Container(
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
                child: Icon(Icons.person_outline, color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
