import 'package:flutter/material.dart';
import '../../../../widgets/dashboard_card.dart';

class CycleCard extends StatelessWidget {
  final int currentCycleDay;
  final String phaseLabel;
  final int daysUntilNextPeriod;
  
  const CycleCard({
    this.currentCycleDay = 14,
    this.phaseLabel = 'Ovulation phase',
    this.daysUntilNextPeriod = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'Day $currentCycleDay',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phaseLabel, style: theme.textTheme.labelLarge,),
                const SizedBox(height: 4,),
                Text(
                  'Next period estimated in $daysUntilNextPeriod days',
                  style: theme.textTheme.bodyMedium,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}