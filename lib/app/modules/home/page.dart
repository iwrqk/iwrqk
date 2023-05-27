import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../routes/pages.dart';
import 'controller.dart';
import 'widgets/user_avatar.dart';
import 'widgets/user_drawer.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  PreferredSize _buildAppbar(BuildContext context) {
    double height = kTextTabBarHeight +
        MediaQuery.of(context).padding.top +
        (controller.currentIndex == 3 ? 1 : 0);

    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: controller.currentIndex == 3
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                )
              : null,
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 7.5, 0, 7.5),
              child: InkWell(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: ClipOval(
                  child: UserAvatar(aspectRatio: 1),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.normalSearch);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: AutoSizeText(
                          L10n.of(context).search,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 17.5,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 7.5, 15, 7.5),
              child: InkWell(
                onTap: () {
                  if (controller.userService.accountService.isLogin) {
                    Get.toNamed(AppRoutes.conversationsPreview);
                  } else {
                    Get.toNamed(AppRoutes.login);
                  }
                },
                child: (controller.userService.notificationsCounts?.total ?? 0) > 0
                    ? Badge(
                        label:
                            controller.userService.notificationsCounts!.total >
                                    0
                                ? Text(
                                    controller
                                        .userService.notificationsCounts!.total
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                : null,
                        child: FaIcon(
                          FontAwesomeIcons.solidEnvelope,
                          color: Colors.grey,
                        ),
                      )
                    : FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        color: Colors.grey,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.init(context);

    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        appBar: _buildAppbar(context),
        drawer: const UserDrawer(),
        body: CupertinoTabScaffold(
          controller: controller.tabController,
          tabBar: CupertinoTabBar(
            activeColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).canvasColor,
            items: controller.listBottomNavigationBarItem,
            onTap: controller.onTap,
            height: kBottomNavigationBarHeight,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          tabBuilder: (context, index) => CupertinoTabView(
            builder: (BuildContext context) => controller.pageList[index],
          ),
        ),
      ),
    );
  }
}
