import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Scales the ornament to the card, without relying on emoji fonts or images.
class TarotCardBack extends StatelessWidget {
  final VoidCallback? onTap;

  const TarotCardBack({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x400D0526),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF432464), Color(0xFF211038)],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0x40E5C78F),
            highlightColor: const Color(0x20E5C78F),
            child: const CustomPaint(
              painter: _CardOrnament(),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardOrnament extends CustomPainter {
  const _CardOrnament();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const gold = Color(0xFFD9B779);
    final stroke = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    final fill = Paint()..color = gold;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, w - 2, h - 2),
        const Radius.circular(9),
      ),
      stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.05, w * 0.84, h * 0.9),
        Radius.circular(w * 0.055),
      ),
      stroke..color = gold.withValues(alpha: 0.45),
    );

    final center = Offset(w / 2, h / 2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.64, height: h * 0.47),
      stroke,
    );
    final moonRadius = w * 0.20;
    final moon = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: center, radius: moonRadius)),
      Path()
        ..addOval(Rect.fromCircle(
          center: center + Offset(w * 0.12, -w * 0.07),
          radius: moonRadius * 0.92,
        )),
    );
    canvas.drawPath(moon, fill);

    void star(Offset point, double radius) {
      final path = Path();
      for (var i = 0; i < 8; i++) {
        final angle = -math.pi / 2 + i * math.pi / 4;
        final r = i.isEven ? radius : radius * 0.25;
        final x = point.dx + math.cos(angle) * r;
        final y = point.dy + math.sin(angle) * r;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path..close(), fill);
    }

    star(Offset(w / 2, h * 0.19), w * 0.065);
    star(Offset(w / 2, h * 0.81), w * 0.065);
    star(Offset(w * 0.72, h * 0.39), w * 0.04);
    star(Offset(w * 0.28, h * 0.61), w * 0.035);
    for (final x in [0.2, 0.8]) {
      for (final y in [0.12, 0.88]) {
        canvas.drawCircle(Offset(w * x, h * y), w * 0.015, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CardOrnament oldDelegate) => false;
}
