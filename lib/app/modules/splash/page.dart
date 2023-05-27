import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: WavePainter(
                    value: controller.animation.value,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Image.asset(
                        "assets/app_icon.png",
                        width: 75,
                        height: 75,
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "IwrQk",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Iwara Quick!",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 10,
                      vertical: 50),
                  child: LinearProgressIndicator(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double value;
  final Color color;

  WavePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color.withOpacity(0.9);
    var path = Path();

    final yCenter = size.height * 0.9;
    final amplitude = size.height / 32;
    final waveLength = size.width * 2;

    path.moveTo(0, yCenter);

    for (int i = 0; i < size.width; i++) {
      double xOffset = i.toDouble();
      double yOffset =
          sin((xOffset / waveLength + value) * pi) * amplitude * 1.5;
      path.lineTo(xOffset, yCenter + yOffset);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    path = Path();
    paint = Paint()
      ..color = Color.alphaBlend(color, Colors.white).withOpacity(0.8);

    for (int i = 0; i < size.width; i++) {
      double xOffset = i.toDouble();
      double yOffset =
          sin((xOffset / waveLength + value) * pi + pi) * amplitude;
      path.lineTo(xOffset, yCenter + yOffset);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
