import 'package:flutter/material.dart';
import '../onboarding/widgets/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
  with SingleTickerProviderStateMixin {
    late final AnimationController _controller;
    late final Animation<double> _fadeAnimation;
    late final Animation<double> _scaleAnimation;

  @override 
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0,0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if(mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override 
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // logo later

              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.spa_outlined,
                  size: 44,
                  color: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 24,),
              Text(
                'Wellspring',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 8,),
              Text(
                'Your daily companion',
                style: theme.textTheme.bodyMedium,
              )
            ],
            ),
          ),
        ),
      ),
    );
  }
}
