import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class MarketSparkline extends StatelessWidget {
  const MarketSparkline({required this.values, required this.color, super.key});

  final List<Decimal> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<Decimal> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final points = values
        .map((value) => double.tryParse(value.toString()) ?? 0)
        .toList(growable: false);
    final minValue = points.reduce((a, b) => a < b ? a : b);
    final maxValue = points.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final path = Path();

    for (var index = 0; index < points.length; index++) {
      final x = points.length == 1
          ? size.width
          : index / (points.length - 1) * size.width;
      final normalized = range == 0 ? 0.5 : (points[index] - minValue) / range;
      final y = size.height - (normalized * (size.height - 10)) - 5;

      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);

    final lastX = points.length == 1 ? size.width : size.width;
    final lastNormalized = range == 0 ? 0.5 : (points.last - minValue) / range;
    final lastY = size.height - (lastNormalized * (size.height - 10)) - 5;
    canvas.drawCircle(Offset(lastX, lastY), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}
