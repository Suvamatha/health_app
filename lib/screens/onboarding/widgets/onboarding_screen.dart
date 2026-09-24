import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/onboarding_page.dart';
import '../../../widgets/page_inicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingSlideData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      icon: Icons.water_drop_outlined,
      title: 'Stay in tune with your body',
      description:
          'Gentle hydration and wellness reminders that fit into your day — no pressure, no guilt.',
    ),
    _OnboardingSlideData(
      icon: Icons.favorite_outline,
      title: 'Track what matters to you',
      description: 'Mood, cycle, symptoms — all in one calm place, at your own pace.',
    ),
    _OnboardingSlideData(
      icon: Icons.auto_awesome_outlined,
      title: 'Small steps, real progress',
      description: 'See your journey build over time, one gentle check-in at a time.',
    ),
  ];

  void _goToNextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    context.go('/dashboard');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLastPage ? 0 : 1,
                  child: TextButton(
                    onPressed: isLastPage ? null : _finishOnboarding,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return OnboardingPage(
                    icon: slide.icon,
                    title: slide.title,
                    description: slide.description,
                  );
                },
              ),
            ),
            PageInicator(count: _slides.length, currentIndex: _currentPage),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _goToNextPage,
                  child: Text(isLastPage ? 'Get started' : 'Next'),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
