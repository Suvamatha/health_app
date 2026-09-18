import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';

class MoodCard extends StatefulWidget {
  const MoodCard({super.key});

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodOption {
  final IconData icon;
  final String label;
  const _MoodOption(this.icon, this.label);
}

class _MoodCardState extends State<MoodCard> {
  int? _selectedIndex;

  static const List<_MoodOption> _moods = [
    _MoodOption(Icons.sentiment_very_dissatisfied_outlined, 'Low'),
    _MoodOption(Icons.sentiment_neutral_outlined, 'Okay'),
    _MoodOption(Icons.sentiment_satisfied_outlined, 'Good'),
    _MoodOption(Icons.sentiment_very_satisfied_outlined, 'Great'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_outline, color: theme.colorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text('Mood check-in', style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.secondary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _moods[index].icon,
                    color: isSelected
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}