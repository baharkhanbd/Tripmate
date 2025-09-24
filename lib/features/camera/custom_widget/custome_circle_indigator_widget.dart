import 'dart:math';

import 'package:flutter/widgets.dart';

class SegmentedSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final int segments;

  const SegmentedSpinner({
    super.key,
    required this.size,
    required this.color,
    this.segments = 12,
  });

  @override
  State<SegmentedSpinner> createState() => _SegmentedSpinnerState();
}

class _SegmentedSpinnerState extends State<SegmentedSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: child,
          );
        },
        child: CustomPaint(
          painter: _SegmentedSpinnerPainter(
            color: widget.color,
            segments: widget.segments,
          ),
        ),
      ),
    );
  }
}

class _SegmentedSpinnerPainter extends CustomPainter {
  final Color color;
  final int segments;

  _SegmentedSpinnerPainter({required this.color, required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final angle = 2 * pi / segments;

    for (int i = 0; i < segments; i++) {
      final startAngle = i * angle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        angle / 2.5, 
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
