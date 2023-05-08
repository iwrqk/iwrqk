import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';

class VideosTabController extends GetxController {
  late BuildContext outterContext;
  late String tag;

  List<String> get tabNameList => [
        L10n.of(outterContext).sort_latest,
        L10n.of(outterContext).sort_trending,
        L10n.of(outterContext).sort_popularity,
        L10n.of(outterContext).sort_most_views,
        L10n.of(outterContext).sort_most_likes,
      ];

  List<String> get tabTagList => [
        "${tag}_latest",
        "${tag}_trending",
        "${tag}_popularity",
        "${tag}_most_views",
        "${tag}_most_likes",
      ];

  List<OrderType> get orderTypeList => [
        OrderType.date,
        OrderType.trending,
        OrderType.popularity,
        OrderType.views,
        OrderType.likes
      ];

  void init(BuildContext context, String tabTag) {
    outterContext = context;
    tag = tabTag;
  }
}
