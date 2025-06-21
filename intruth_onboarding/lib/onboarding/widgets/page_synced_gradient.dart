import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class PageSyncedGradient extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Widget? child;

  const PageSyncedGradient({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.child,
  }) : super(key: key);

  @override
  State<PageSyncedGradient> createState() => _PageSyncedGradientState();
}

class _PageSyncedGradientState extends State<PageSyncedGradient>
    with TickerProviderStateMixin {
  late AnimationController _baseController;
  late AnimationController _pageController;
  late Animation<double> _baseAnimation;
  late Animation<double> _pageAnimation;

  // Color schemes for each page
  final List<List<Color>> pageColorSchemes = [
    // Page 1 - Welcome (Cool blues and purples)
    [
      Color(0xFF6A00FF),
      Color(0xFF00D4FF),
      Color(0xFF0066FF),
      Color(0xFF8800FF),
    ],
    // Page 2 - Share Your Truth (Warm oranges and pinks)
    [
      Color(0xFFFF0055),
      Color(0xFFFF6600),
      Color(0xFFFFAA00),
      Color(0xFFFF0088),
    ],
    // Page 3 - Build Connections (Greens and teals)
    [
      Color(0xFF00FF88),
      Color(0xFF00D4FF),
      Color(0xFF00AA44),
      Color(0xFF00FFCC),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _baseController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _pageController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _baseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _baseController,
      curve: Curves.linear,
    ));
    
    _pageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(PageSyncedGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _pageController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _baseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Color> _getCurrentColors() {
    final pageIndex = widget.currentPage.clamp(0, pageColorSchemes.length - 1);
    return pageColorSchemes[pageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_baseAnimation, _pageAnimation]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getCurrentColors(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: PageSyncedGradientPainter(
              baseAnimation: _baseAnimation,
              pageAnimation: _pageAnimation,
              colors: _getCurrentColors(),
              currentPage: widget.currentPage,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class PageSyncedGradientPainter extends CustomPainter {
  final Animation<double> baseAnimation;
  final Animation<double> pageAnimation;
  final List<Color> colors;
  final int currentPage;

  PageSyncedGradientPainter({
    required this.baseAnimation,
    required this.pageAnimation,
    required this.colors,
    required this.currentPage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Base animated value for continuous motion
    final baseValue = baseAnimation.value * 2 * math.pi;
    
    // Page transition effect
    final pageTransition = pageAnimation.value;
    
    // Create flowing gradient with more movement
    final center = Offset(
      size.width * (0.5 + math.sin(baseValue) * 0.2),
      size.height * (0.5 + math.cos(baseValue * 0.7) * 0.2),
    );
    
    // Calculate gradient colors with smooth transitions
    final gradientColors = <Color>[];
    final colorStops = <double>[];
    
    for (int i = 0; i < colors.length; i++) {
      final t = (i / (colors.length - 1));
      gradientColors.add(colors[i].withOpacity(0.8 + pageTransition * 0.2));
      colorStops.add(t);
    }
    
    // Main gradient
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        size.width * 0.8,
        gradientColors,
        colorStops,
        TileMode.clamp,
      )
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(rect, paint);
    
    // Add overlay gradient for depth
    final overlayCenter = Offset(
      size.width * (0.5 - math.sin(baseValue * 1.2) * 0.25),
      size.height * (0.5 - math.cos(baseValue * 0.9) * 0.25),
    );
    
    final overlayPaint = Paint()
      ..shader = ui.Gradient.radial(
        overlayCenter,
        size.width * 0.6,
        [
          colors[0].withOpacity(0.3 * (1 - pageTransition)),
          colors[1].withOpacity(0.1),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
        TileMode.clamp,
      )
      ..blendMode = BlendMode.screen;
    
    canvas.drawRect(rect, overlayPaint);
    
    // Add subtle vignette
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.width * 0.8,
        [
          Colors.transparent,
          Colors.black.withOpacity(0.2),
        ],
        [0.6, 1.0],
        TileMode.clamp,
      );
    
    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(PageSyncedGradientPainter oldDelegate) {
    return true; // Always repaint for smooth animation
  }
}