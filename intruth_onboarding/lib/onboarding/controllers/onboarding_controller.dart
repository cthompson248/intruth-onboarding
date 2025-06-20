import 'package:flutter/foundation.dart';

class OnboardingController extends ChangeNotifier {
  int _currentPage = 0;
  final int totalPages;
  final Function(int)? onPageChanged;

  OnboardingController({
    required this.totalPages,
    this.onPageChanged,
  });

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == totalPages - 1;

  void setCurrentPage(int page) {
    _currentPage = page;
    onPageChanged?.call(page);
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      setCurrentPage(_currentPage + 1);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      setCurrentPage(_currentPage - 1);
    }
  }
}