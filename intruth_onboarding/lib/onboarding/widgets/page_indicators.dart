import 'package:flutter/material.dart';

class PageIndicators extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const PageIndicators({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}