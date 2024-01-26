import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/enums/types.dart';

class VideosTabController extends GetxController {
  late String tag;

  List<String> get tabNameList => [
        t.sort.latest,
        t.sort.trending,
        t.sort.popularity,
        t.sort.most_views,
        t.sort.most_likes,
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

  void init(String tabTag) {
    tag = tabTag;
  }
}
