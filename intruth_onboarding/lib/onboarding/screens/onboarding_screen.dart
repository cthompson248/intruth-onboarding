import 'package:flutter/material.dart';
import '../models/onboarding_page_model.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicators.dart';
import '../widgets/page_synced_gradient.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const OnboardingScreen({
    super.key,
    required this.pages,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingController _controller;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController(
      totalPages: widget.pages.length,
      onPageChanged: (index) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_controller.isLastPage) {
      widget.onComplete?.call();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSkip() {
    widget.onSkip?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Page-synced gradient background
            Positioned.fill(
              child: PageSyncedGradient(
                currentPage: _controller.currentPage,
                totalPages: widget.pages.length,
              ),
            ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: _controller.setCurrentPage,
            itemCount: widget.pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                page: widget.pages[index],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _handleSkip,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                PageIndicators(
                  totalPages: widget.pages.length,
                  currentPage: _controller.currentPage,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _controller.isLastPage ? 'Get Started' : 'Next',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}