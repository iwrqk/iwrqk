import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.init(context);

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
