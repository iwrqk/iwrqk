import 'package:flutter/material.dart';

class TabIndicator extends Decoration {
  final BuildContext context;
  const TabIndicator(this.context);

  @override
  TabPainter createBoxPainter([VoidCallback? onChanged]) {
    return TabPainter(onChanged, context);
  }
}

class TabPainter extends BoxPainter {
  final BuildContext context;
  TabPainter(VoidCallback? onChanged, this.context);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Rect rect = Offset(offset.dx, (configuration.size!.height - 3.5)) &
        Size(configuration.size!.width, 3.5);
    Paint paint = Paint();
    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(8),
        topLeft: const Radius.circular(8),
      ),
      paint,
    );
  }
}
