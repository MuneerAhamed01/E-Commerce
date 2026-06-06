import 'package:flutter/material.dart';

/// Multicolor Google "G" mark for social sign-in buttons.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const stroke = 3.5;

    void drawArc(Color color, double start, double sweep) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - stroke / 2),
        start,
        sweep,
        false,
        paint,
      );
    }

    drawArc(const Color(0xFFEA4335), -0.4, 1.6);
    drawArc(const Color(0xFFFBBC05), 1.2, 1.2);
    drawArc(const Color(0xFF34A853), 2.4, 1.2);
    drawArc(const Color(0xFF4285F4), 3.6, 1.4);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - stroke / 2,
        center.dy - stroke / 2,
        radius * 0.55,
        stroke,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
