import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

class IwrProgressIndicator extends CircularProgressIndicator {
  const IwrProgressIndicator({
    Key? key,
    double strokeWidth = -1,
    Animation<Color?>? valueColor,
    String? semanticsLabel,
    String? semanticsValue,
  }) : super(
          key: key,
          strokeWidth: strokeWidth,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  @override
  State<IwrProgressIndicator> createState() => _IwrProgressIndicatorState();
}

class _IwrProgressIndicatorState extends State<IwrProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
    _animation = Tween(begin: -1.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
            constraints: BoxConstraints(
              maxWidth: 72,
              maxHeight: 72,
            ),
            child: CustomPaint(
              painter: _CustomQuarterArcProgressPainter(
                valueColor: widget.valueColor == null
                    ? Theme.of(context).indicatorColor
                    : widget.valueColor!.value!,
                value: _animation.value,
                strokeWidth: widget.strokeWidth,
              ),
              child: Container(),
            ));
      },
    );
  }
}

class _CustomQuarterArcProgressPainter extends CustomPainter {
  final double value;
  double? strokeWidth;
  final Color valueColor;

  _CustomQuarterArcProgressPainter({
    required this.valueColor,
    required this.value,
    this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor =
        strokeWidth == -1 ? min(size.height, size.width) / 72 : 1;

    strokeWidth == -1 ? strokeWidth = 5 : strokeWidth;

    Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth! * scaleFactor
      ..style = PaintingStyle.stroke;

    double radius = (size.width - strokeWidth! * scaleFactor) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    double startAngle = value * math.pi;
    double endAngle = startAngle + math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
    startAngle += math.pi;
    endAngle += math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CustomQuarterArcProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.valueColor != valueColor;
  }
}
