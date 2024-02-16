import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/media_preview/media_preview_grid/controller.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';

class UploadedMediaController extends GetxController {
  List<String> get tabNameList => [
        t.sort.latest,
        t.sort.trending,
        t.sort.popularity,
        t.sort.most_views,
        t.sort.most_likes,
      ];

  List<OrderType> get orderTypeList => [
        OrderType.date,
        OrderType.trending,
        OrderType.popularity,
        OrderType.views,
        OrderType.likes
      ];

  late List<String> tabTagList;

  late UserModel user;
  late MediaSourceType sourceType;

  @override
  void onInit() {
    user = Get.arguments["user"];
    sourceType = Get.arguments["sourceType"];

    String tag = "${user.id}_${sourceType.name}";

    tabTagList = [
      "${tag}_latest",
      "${tag}_trending",
      "${tag}_popularity",
      "${tag}_most_views",
      "${tag}_most_likes",
    ];

    for (String tag in tabTagList) {
      Get.lazyPut(() => MediaPreviewGridController(), tag: tag);
    }

    super.onInit();
  }
}
