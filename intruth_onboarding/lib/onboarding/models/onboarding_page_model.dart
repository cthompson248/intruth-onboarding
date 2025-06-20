import 'package:flutter/material.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Widget? customWidget;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.backgroundColor = Colors.white,
    this.customWidget,
  });
}