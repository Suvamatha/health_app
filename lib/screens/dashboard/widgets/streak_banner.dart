import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';

class StreakBanner extends StatelessWidget {
  final int streakDays;

  const StreakBanner({this.streakDays = 5,super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(Icons.local_fire_department_outlined, color: theme.colorScheme.tertiary,),
          const SizedBox(width: 12,),
          Expanded(
            child: Text(
              '$streakDays -day check-in streak - keep it going',
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.tertiary),
            ),
          )
        ],
      ),
    );
  }
}