import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../data/services/config_service.dart';
import '../../data/services/user_service.dart';
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
    AppRoutes.subscription: FontAwesomeIcons.solidBell,
    AppRoutes.videos: FontAwesomeIcons.video,
    AppRoutes.images: FontAwesomeIcons.solidImage,
    AppRoutes.forum: FontAwesomeIcons.solidComments
  };

  Map<String, Widget> get tabIcons =>
      iconDatas.map((key, value) => MapEntry(key, FaIcon(value, size: 30)));

  BuildContext get _context => Get.find<HomeController>().outterContext;

  Map<String, String> get tabTitles => <String, String>{
        AppRoutes.subscription: L10n.of(_context).subscriptions,
        AppRoutes.videos: L10n.of(_context).videos,
        AppRoutes.images: L10n.of(_context).images,
        AppRoutes.forum: L10n.of(_context).forum,
      };

  List<String> tabNameList = <String>[
    AppRoutes.subscription,
    AppRoutes.videos,
    AppRoutes.images,
    AppRoutes.forum,
  ];

  List<GlobalKey<NavigatorState>> navigatorKeys = <GlobalKey<NavigatorState>>[
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
}

class HomeController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final ConfigService configService = Get.find<ConfigService>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CupertinoTabController tabController = CupertinoTabController();
  final RxInt _currentIndex = 0.obs;
  late BuildContext outterContext;

  int get currentIndex => _currentIndex.value;

  bool tapAwait = false;

  late List<MediaGridTabController> mediaGridTabControllers;
  late ForumTabController forumTabController;

  RxList<String> tabNameList = tabPages.tabNameList.obs;

  List<Widget> get pageList => tabPages.tabPages.values.toList();

  List<GlobalKey<NavigatorState>> get navigatorKeys => tabPages.navigatorKeys;

  List<BottomNavigationBarItem> get listBottomNavigationBarItem =>
      tabNameList.map((key) {
        return BottomNavigationBarItem(
          icon: tabPages.tabIcons[key]!,
          label: tabPages.tabTitles[key]!,
        );
      }).toList();

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
  }

  void init(BuildContext context) {
    outterContext = context;
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
        },
        duration: const Duration(milliseconds: 300),
        awaitComplete: false,
      );
    } else {
      _currentIndex.value = index;
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

  Future<bool> onWillPop() async {
    return navigatorKeys[currentIndex].currentState!.canPop();
  }
}
