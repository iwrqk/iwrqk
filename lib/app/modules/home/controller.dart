import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../data/services/config_service.dart';
import '../../routes/pages.dart';
import '../tabs/forum_tab/controller.dart';
import '../tabs/forum_tab/page.dart';
import '../tabs/images_tab/page.dart';
import '../tabs/media_grid_tab/controller.dart';
import '../tabs/subscription_tab/page.dart';
import '../tabs/videos_tab/page.dart';

final TabPages tabPages = TabPages();

class TabPages {
  List<String> scrollableTabTags = [
    "subscription_tab",
    "videos_tab",
    "images_tab",
    "forum_tab"
  ];

  Map<String, Widget> get tabPages => <String, Widget>{
        AppRoutes.subscription:
            SubscriptionTabPage(tabTag: scrollableTabTags[0]),
        AppRoutes.videos: VideosTabPage(tabTag: scrollableTabTags[1]),
        AppRoutes.images: ImagesTabPage(tabTag: scrollableTabTags[2]),
        AppRoutes.forum: ForumTabPage(tabTag: scrollableTabTags[3]),
      };

  final Map<String, IconData> iconDatas = <String, IconData>{
    AppRoutes.subscription: Icons.subscriptions_outlined,
    AppRoutes.videos: Icons.video_library_outlined,
    AppRoutes.images: Icons.photo_library_outlined,
    AppRoutes.forum: Icons.forum_outlined,
  };

  final Map<String, IconData> activeIconDatas = <String, IconData>{
    AppRoutes.subscription: Icons.subscriptions,
    AppRoutes.videos: Icons.video_library,
    AppRoutes.images: Icons.photo_library,
    AppRoutes.forum: Icons.forum,
  };

  Map<String, Widget> get tabIcons =>
      iconDatas.map((key, value) => MapEntry(key, Icon(value)));

  Map<String, Widget> get tabActiveIcons =>
      activeIconDatas.map((key, value) => MapEntry(key, Icon(value)));

  Map<String, String> get tabTitles => <String, String>{
        AppRoutes.subscription: t.nav.subscriptions,
        AppRoutes.videos: t.nav.videos,
        AppRoutes.images: t.nav.images,
        AppRoutes.forum: t.nav.forum,
      };

  List<String> tabNameList = <String>[
    AppRoutes.subscription,
    AppRoutes.videos,
    AppRoutes.images,
    AppRoutes.forum,
  ];
}

class HomeController extends GetxController {
  final ConfigService configService = Get.find<ConfigService>();
  DateTime? _lastPressedAt;

  List<Widget> get pageList => tabPages.tabPages.values.toList();

  List<String> tabNameList = tabPages.tabNameList;

  late List<MediaGridTabController> mediaGridTabControllers;
  late ForumTabController forumTabController;

  PageController? pageController;
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  bool tapAwait = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();

    for (final String tabTag in tabPages.scrollableTabTags) {
      Get.lazyPut(() => MediaGridTabController(), tag: tabTag);
    }

    mediaGridTabControllers = tabPages.scrollableTabTags
        .map((e) => Get.find<MediaGridTabController>(tag: e))
        .toList();
    forumTabController = Get.find<ForumTabController>();

    pageController = PageController(initialPage: currentIndex);
  }

  Future<void> onTap(int index) async {
    if (index == currentIndex) {
      await procressDoubleTap(
        onTap: () {
          if (index == 3) {
            forumTabController.scrollToTop();
          } else {
            mediaGridTabControllers[index].scrollToTop();
          }
        },
        onDoubleTap: () {
          if (index == 3) {
            forumTabController.scrollToTopRefresh();
          } else {
            mediaGridTabControllers[index].scrollToTopRefresh();
          }
          HapticFeedback.lightImpact();
        },
        duration: const Duration(milliseconds: 300),
        awaitComplete: false,
      );
    } else {
      _currentIndex.value = index;
      pageController!.jumpToPage(index);
    }
  }

  Future<void> procressDoubleTap({
    required VoidCallback onTap,
    required VoidCallback onDoubleTap,
    required Duration duration,
    required bool awaitComplete,
  }) async {
    if (!tapAwait) {
      tapAwait = true;

      if (awaitComplete) {
        await Future<void>.delayed(duration);
        if (tapAwait) {
          tapAwait = false;
          onTap();
        }
      } else {
        onTap();
        await Future<void>.delayed(duration);
        tapAwait = false;
      }
    } else {
      tapAwait = false;
      onDoubleTap();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      _lastPressedAt = DateTime.now();
      SmartDialog.showToast(t.message.exit_app);
      return;
    }
    SystemNavigator.pop();
  }
}
