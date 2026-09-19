import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final iconContainerSize = (screenWidth * 0.38).clamp(110.0, 170.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconContainerSize * 0.45, // icon scales WITH the container
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}