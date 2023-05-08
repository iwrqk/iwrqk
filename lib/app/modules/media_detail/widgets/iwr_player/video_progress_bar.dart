/*
  This code contains modifications to the original [chewie] library,
  which is licensed under the MIT license. The modifications are also subject
  to the terms of the MIT license. For more information, please see the LICENSE
  file included with the original library.
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatefulWidget {
  const VideoProgressBar(this.controller,
      {this.onDragEnd,
      this.onDragStart,
      this.onDragUpdate,
      Key? key,
      required this.barHeight,
      required this.handleHeight,
      required this.drawShadow,
      this.previewPositionAfterAdjust})
      : super(key: key);

  final VideoPlayerController controller;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;
  final int? previewPositionAfterAdjust;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  @override
  // ignore: library_private_types_in_public_api
  _VideoProgressBarState createState() {
    return _VideoProgressBarState();
  }
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  void listener() {
    if (!mounted) return;
    setState(() {});
  }

  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  void _seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject()! as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position = controller.value.duration * relative;
    controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }

        widget.onDragStart?.call();
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        final shouldSeekToRelativePosition =
            !Platform.isAndroid || !controller.value.isBuffering;
        if (shouldSeekToRelativePosition) {
          _seekToRelativePosition(details.globalPosition);
        }

        widget.onDragUpdate?.call();
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }

        widget.onDragEnd?.call();
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _seekToRelativePosition(details.globalPosition);
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: CustomPaint(
            painter: _ProgressBarPainter(
              previewPositionAfterAdjust: widget.previewPositionAfterAdjust,
              value: controller.value,
              barHeight: widget.barHeight,
              handleHeight: widget.handleHeight,
              drawShadow: widget.drawShadow,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({
    this.previewPositionAfterAdjust,
    required this.value,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
  });

  VideoPlayerValue value;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;
  final int? previewPositionAfterAdjust;

  final Paint _playedPaint = Paint()
    ..color = const Color.fromARGB(
      120,
      255,
      255,
      255,
    );
  final Paint _bufferedPaint = Paint()
    ..color = const Color.fromARGB(
      60,
      255,
      255,
      255,
    );
  final Paint _handlePaint = Paint()
    ..color = const Color.fromARGB(
      255,
      255,
      255,
      255,
    );
  final Paint _backgroundPaint = Paint()
    ..color = const Color.fromARGB(
      20,
      255,
      255,
      255,
    );

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseOffset = size.height / 2 - barHeight / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(size.width, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      _backgroundPaint,
    );
    if (!value.isInitialized) {
      return;
    }
    double playedPartPercent;
    if (previewPositionAfterAdjust != null) {
      playedPartPercent =
          previewPositionAfterAdjust! / value.duration.inMilliseconds;
    } else {
      playedPartPercent =
          value.position.inMilliseconds / value.duration.inMilliseconds;
    }
    final double playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * size.width;
      final double end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, baseOffset),
            Offset(end, baseOffset + barHeight),
          ),
          const Radius.circular(4.0),
        ),
        _bufferedPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(playedPart, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      _playedPaint,
    );

    if (drawShadow) {
      final Path shadowPath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(playedPart, baseOffset + barHeight / 2),
            radius: handleHeight,
          ),
        );

      canvas.drawShadow(shadowPath, Colors.black, 0.2, false);
    }

    canvas.drawCircle(
      Offset(playedPart, baseOffset + barHeight / 2),
      handleHeight,
      _handlePaint,
    );
  }
}
