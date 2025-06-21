import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

class ChromaGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration animationDuration;
  final double waveAmplitude;
  final double waveFrequency;
  final Widget? child;

  const ChromaGradientBackground({
    Key? key,
    this.colors = const [
      Color(0xFF6A00FF),
      Color(0xFF00D4FF),
      Color(0xFF00FF88),
      Color(0xFFFFAA00),
      Color(0xFFFF0055),
    ],
    this.animationDuration = const Duration(seconds: 10),
    this.waveAmplitude = 0.1,
    this.waveFrequency = 2.0,
    this.child,
  }) : super(key: key);

  @override
  State<ChromaGradientBackground> createState() => _ChromaGradientBackgroundState();
}

class _ChromaGradientBackgroundState extends State<ChromaGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: ChromaGradientPainter(
            animation: _animation,
            colors: widget.colors,
            waveAmplitude: widget.waveAmplitude,
            waveFrequency: widget.waveFrequency,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class ChromaGradientPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Color> colors;
  final double waveAmplitude;
  final double waveFrequency;

  ChromaGradientPainter({
    required this.animation,
    required this.colors,
    required this.waveAmplitude,
    required this.waveFrequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Create a path with wave distortion
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Calculate animated gradient positions
    final animationValue = animation.value * 2 * math.pi;
    
    // Create multiple gradient layers for depth
    for (int layer = 0; layer < 3; layer++) {
      final layerOpacity = 0.6 - (layer * 0.2);
      final phaseShift = layer * math.pi / 3;
      
      // Create gradient with animated colors
      final gradientColors = _generateAnimatedColors(animationValue + phaseShift);
      
      // Calculate gradient center with wave motion
      final centerX = 0.5 + math.sin(animationValue + phaseShift) * waveAmplitude;
      final centerY = 0.5 + math.cos(animationValue * 0.7 + phaseShift) * waveAmplitude;
      
      final center = Offset(size.width * centerX, size.height * centerY);
      final radius = size.width * 0.8;
      
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          gradientColors,
          _generateColorStops(gradientColors.length),
          TileMode.clamp,
          _createRotationMatrix(animationValue * 0.5 + phaseShift),
        )
        ..blendMode = layer == 0 ? BlendMode.srcOver : BlendMode.screen
        ..color = Colors.white.withOpacity(layerOpacity);
      
      canvas.drawPath(path, paint);
    }
    
    // Add subtle noise texture
    final noisePaint = Paint()
      ..shader = _createNoiseShader(size, animationValue)
      ..blendMode = BlendMode.multiply
      ..color = Colors.white.withOpacity(0.05);
    
    canvas.drawRect(rect, noisePaint);
  }

  List<Color> _generateAnimatedColors(double phase) {
    final List<Color> animatedColors = [];
    final colorCount = colors.length;
    
    for (int i = 0; i < colorCount; i++) {
      final t = (math.sin(phase + (i * 2 * math.pi / colorCount)) + 1) / 2;
      final nextIndex = (i + 1) % colorCount;
      
      final color = Color.lerp(
        colors[i],
        colors[nextIndex],
        t,
      )!;
      
      animatedColors.add(color);
    }
    
    return animatedColors;
  }

  List<double> _generateColorStops(int count) {
    final List<double> stops = [];
    for (int i = 0; i < count; i++) {
      stops.add(i / (count - 1));
    }
    return stops;
  }

  Float64List _createRotationMatrix(double rotation) {
    final double cos = math.cos(rotation);
    final double sin = math.sin(rotation);
    
    return Float64List.fromList([
      cos, -sin, 0, 0,
      sin, cos, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]);
  }

  ui.Shader _createNoiseShader(Size size, double phase) {
    // Create a simple noise pattern using gradients
    final noiseColors = [
      Colors.white.withOpacity(0.0),
      Colors.white.withOpacity(0.1),
      Colors.white.withOpacity(0.0),
    ];
    
    return ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.width * 0.1, size.height * 0.1),
      noiseColors,
      null,
      TileMode.repeated,
      _createRotationMatrix(phase * 0.1),
    );
  }

  @override
  bool shouldRepaint(ChromaGradientPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.colors != colors ||
        oldDelegate.waveAmplitude != waveAmplitude ||
        oldDelegate.waveFrequency != waveFrequency;
  }
}