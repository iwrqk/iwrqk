import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

class SubscriptionTabController extends GetxController {
  late String tag;

  List<String> get tabNameList => [
        t.nav.videos,
        t.nav.images,
      ];

  List<String> get tabTagList => [
        "${tag}_videos",
        "${tag}_images",
      ];

  void init(String tabTag) {
    tag = tabTag;
  }
}
