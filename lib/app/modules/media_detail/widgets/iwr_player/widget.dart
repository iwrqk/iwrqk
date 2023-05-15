import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class IwrPlayer extends StatelessWidget {
  final Map<String, String> resolutions;
  final String title;
  final String author;

  const IwrPlayer({
    super.key,
    required this.resolutions,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IwrPlayerController>(
      init: IwrPlayerController(
        resolutions: resolutions,
        title: title,
        author: author,
      ),
      builder: (controller) {
        return BetterPlayer(
          controller: controller.betterPlayerController,
        );
      },
    );
  }
}
