import 'dart:ui';
import 'package:flutter/material.dart';

class IwrIconProgressIndicator extends CircularProgressIndicator {
  const IwrIconProgressIndicator({
    Key? key,
    double strokeWidth = 4,
    Animation<Color?>? valueColor,
    double? value,
  }) : super(
          key: key,
          strokeWidth: strokeWidth,
          valueColor: valueColor,
          value: value,
        );

  @override
  State<IwrIconProgressIndicator> createState() =>
      _IwrIconProgressIndicatorState();
}

class _IwrIconProgressIndicatorState extends State<IwrIconProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 72,
        maxHeight: 72,
      ),
      child: CustomPaint(
        painter: _IwrIconProgressPainter(
          valueColor: widget.valueColor == null
              ? Theme.of(context).indicatorColor
              : widget.valueColor!.value!,
          value: widget.value ?? 0,
          strokeWidth: widget.strokeWidth,
        ),
        child: Container(),
      ),
    );
  }
}

class _IwrIconProgressPainter extends CustomPainter {
  final double value;
  double strokeWidth;
  final Color valueColor;

  _IwrIconProgressPainter({
    required this.valueColor,
    required this.value,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.longestSide / 2, size.longestSide / 2);

    if (value == 0) {
      return;
    } else if (value >= 0.2) {
      final Offset trianglePoint1 =
          center + Offset(-size.longestSide / 16, -size.longestSide / 8);
      final Offset trianglePoint2 = center + Offset(size.longestSide / 8, 0);
      final Offset trianglePoint3 =
          center + Offset(-size.longestSide / 16, size.longestSide / 8);

      final Path trianglePath = Path()
        ..moveTo(trianglePoint1.dx, trianglePoint1.dy)
        ..lineTo(trianglePoint2.dx, trianglePoint2.dy)
        ..lineTo(trianglePoint3.dx, trianglePoint3.dy)
        ..close();

      final Paint trianglePaint = Paint()
        ..color = valueColor
        ..style = PaintingStyle.fill
        ..strokeWidth = strokeWidth;

      canvas.drawPath(trianglePath, trianglePaint);
    }

    final Offset rectanglePoint1 = center + Offset(0, -size.longestSide / 4);
    final Offset rectanglePoint2 = center + Offset(size.longestSide / 4, 0);
    final Offset rectanglePoint3 = center + Offset(0, size.longestSide / 4);
    final Offset rectanglePoint4 =
        center + Offset(-size.longestSide / 4 * 0.75, 0);

    final Path path = Path()
      ..moveTo(rectanglePoint1.dx, rectanglePoint1.dy)
      ..lineTo(rectanglePoint2.dx, rectanglePoint2.dy)
      ..lineTo(rectanglePoint3.dx, rectanglePoint3.dy)
      ..lineTo(rectanglePoint4.dx, rectanglePoint4.dy)
      ..close();

    final PathMetric pathMetric = path.computeMetrics().first;
    final Path extractPath = pathMetric.extractPath(
      0,
      pathMetric.length * value,
    );

    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_IwrIconProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.valueColor != valueColor;
  }
}
