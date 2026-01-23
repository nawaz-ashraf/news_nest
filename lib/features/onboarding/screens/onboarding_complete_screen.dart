import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/providers/onboarding_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

/// Onboarding Complete Screen - Celebration screen after completing setup
class OnboardingCompleteScreen extends StatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  State<OnboardingCompleteScreen> createState() =>
      _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends State<OnboardingCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Start animations
    _scaleController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Animated checkmark
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Title
                  Text(
                    'You\'re All Set!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Your personalized news feed is ready.\nLet\'s explore what\'s happening!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Selected interests summary
                  if (provider.selectedInterests.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.interests,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Your Interests',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.selectedInterests.map((
                              interest,
                            ) {
                              return Chip(
                                label: Text(
                                  interest,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Start exploring button
                  PrimaryButton(
                    text: 'Start Exploring',
                    onPressed: () => context.go(AppRoutes.home),
                    icon: Icons.explore,
                    size: ButtonSize.large,
                  ),
                ],
              ),
            ),
          ),
          // Celebration particles (simple custom animation)
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _CelebrationPainter(
                  progress: _confettiController.value,
                  primaryColor: theme.colorScheme.primary,
                  secondaryColor: theme.colorScheme.secondary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Custom painter for celebration particles
class _CelebrationPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _CelebrationPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [
      primaryColor,
      secondaryColor,
      Colors.orange,
      Colors.pink,
      Colors.yellow,
    ];

    // Draw particles
    for (int i = 0; i < 30; i++) {
      final x =
          (size.width * 0.1) + (size.width * 0.8 * ((i * 37) % 100) / 100);
      final startY = -20.0;
      final endY = size.height + 20;
      final y = startY + (endY - startY) * progress;

      final opacity = 1.0 - progress;
      paint.color = colors[i % colors.length].withValues(alpha: opacity);

      final particleSize = 4.0 + (i % 3) * 2;
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
