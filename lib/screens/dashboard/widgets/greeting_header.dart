import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$_greeting,', style:  theme.textTheme.bodyMedium,),
            Text(name, style: theme.textTheme.displayLarge,),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.person_outline, color: theme.colorScheme.primary,),
        ),
      ],
    );
  }
}
