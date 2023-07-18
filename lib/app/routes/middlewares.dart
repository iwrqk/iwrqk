import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages.dart';

class MediaPageMiddlewares extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.currentRoute == AppRoutes.mediaDetail) {
      Get.close(1);
    }
    return null;
  }
}
