import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/primary_button.dart';

/// Welcome Screen - First screen of onboarding flow
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WelcomeSlide> _slides = const [
    WelcomeSlide(
      icon: Icons.newspaper,
      title: 'Stay Informed',
      description:
          'Get the latest news from trusted sources, tailored to your interests.',
      color: Color(0xFF6366F1),
    ),
    WelcomeSlide(
      icon: Icons.location_on,
      title: 'Local Coverage',
      description:
          'Never miss what\'s happening in your city with personalized local news.',
      color: Color(0xFF8B5CF6),
    ),
    WelcomeSlide(
      icon: Icons.bookmark,
      title: 'Save for Later',
      description:
          'Bookmark articles and read them offline, anytime, anywhere.',
      color: Color(0xFFEC4899),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.interests);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.interests),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return _buildSlidePage(slide, theme);
                },
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _slides[_currentPage].color
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: _currentPage == _slides.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: _nextPage,
                icon: _currentPage == _slides.length - 1
                    ? Icons.arrow_forward
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidePage(WelcomeSlide slide, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [slide.color.withValues(alpha: 0.8), slide.color],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: slide.color.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(slide.icon, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            slide.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            slide.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Data class for welcome slides
class WelcomeSlide {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const WelcomeSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
