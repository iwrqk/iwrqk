import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';

class SubscriptionTabController extends GetxController {
  late BuildContext outterContext;
  late String tag;

  List<String> get tabNameList => [
        L10n.of(outterContext).videos,
        L10n.of(outterContext).images,
      ];

  List<String> get tabTagList => [
        "${tag}_videos",
        "${tag}_images",
      ];

  void init(BuildContext context, String tabTag) {
    outterContext = context;
    tag = tabTag;
  }
}
