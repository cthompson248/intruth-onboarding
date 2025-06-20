import 'package:flutter/material.dart';
import 'models/onboarding_page_model.dart';
import 'screens/onboarding_screen.dart';

class OnboardingFlow extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final List<OnboardingPageModel>? customPages;

  const OnboardingFlow({
    super.key,
    this.onComplete,
    this.onSkip,
    this.customPages,
  });

  static final List<OnboardingPageModel> defaultPages = [
    const OnboardingPageModel(
      title: 'Welcome to InTruth',
      description: 'Discover a new way to connect and share authentically with your community.',
      imagePath: 'assets/images/onboarding_1.png',
      backgroundColor: Color(0xFF121212),
    ),
    const OnboardingPageModel(
      title: 'Share Your Truth',
      description: 'Express yourself freely in a safe and supportive environment.',
      imagePath: 'assets/images/onboarding_2.png',
      backgroundColor: Color(0xFF1A1A1A),
    ),
    const OnboardingPageModel(
      title: 'Build Connections',
      description: 'Connect with like-minded individuals who value authenticity.',
      imagePath: 'assets/images/onboarding_3.png',
      backgroundColor: Color(0xFF0D0D0D),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      pages: customPages ?? defaultPages,
      onComplete: onComplete ?? () => _handleComplete(context),
      onSkip: onSkip ?? () => _handleSkip(context),
    );
  }

  void _handleComplete(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _handleSkip(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}