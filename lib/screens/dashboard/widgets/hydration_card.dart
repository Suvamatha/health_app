import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';

class HydrationCard extends StatefulWidget {
  final int goalGlasses;

  const HydrationCard({required this.goalGlasses,super.key});

  @override
  State<HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<HydrationCard> {
  int _glassesLogged = 3; //dummy starting value

  void _addGlass() {
    if (_glassesLogged < widget.goalGlasses) {
      setState(() {
        _glassesLogged++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _glassesLogged / widget.goalGlasses;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, color: theme.colorScheme.primary, size: 20,),
              const SizedBox(width: 8,),
              Text('Hydration', style: theme.textTheme.labelLarge,),
            ],
          ),
          const SizedBox(height: 12,),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 6,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),
              Text('$_glassesLogged/${widget.goalGlasses}', style: theme.textTheme.bodyMedium,),
            ],
          ),
          const SizedBox(height: 12,),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _addGlass,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add glass'),
            ),
          )
        ],
      ),
    );
  }
}