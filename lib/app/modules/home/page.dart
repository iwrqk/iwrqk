import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/app_bar.dart';
import 'widgets/user_drawer.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        controller.onBackPressed(context);
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: HomeAppBar(
          onAvatarTap: () {
            controller.openDrawer();
          },
        ),
        drawer: const UserDrawer(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.currentIndex = index;
          },
          children: controller.pageList,
        ),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            onDestinationSelected: controller.onTap,
            selectedIndex: controller.currentIndex,
            destinations: controller.tabNameList.map((key) {
              return NavigationDestination(
                icon: tabPages.tabIcons[key]!,
                selectedIcon: tabPages.tabActiveIcons[key]!,
                label: tabPages.tabTitles[key]!,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
