import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/app_bar_switcher.dart';
import '../../../data/enums/types.dart';
import 'controller.dart';
import 'widgets/favorite_media_preview_list/widget.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.center,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: [
          Tab(text: t.nav.videos),
          Tab(text: t.nav.images),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBarSwitcher(
          visible: controller.enableMultipleSelection,
          primary: AppBar(
            title: Text(t.user.favorites),
            actions: [
              // IconButton(
              //   onPressed: () => Get.toNamed('/favoritesSearch'),
              //   icon: const Icon(Icons.search),
              // ),
              PopupMenuButton<String>(
                onSelected: (String type) {
                  switch (type) {
                    case 'all':
                      controller.unfavoriteAll();
                      break;
                    case 'multiple':
                      controller.enableMultipleSelection = true;
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Text(t.records.delete_all),
                  ),
                  PopupMenuItem<String>(
                    value: 'multiple',
                    child: Text(t.records.multiple_selection_mode),
                  ),
                ],
              ),
            ],
          ),
          secondary: AppBar(
            titleSpacing: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                controller.enableMultipleSelection = false;
                controller.checkedVideoList.clear();
                controller.checkedImageList.clear();
                controller.checkedCount = 0;
              },
              icon: const Icon(Icons.close_outlined),
            ),
            title: Text(
              t.records.selected_num(num: controller.checkedCount),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: controller.toggleCheckedAll,
                child: Text(t.records.select_inverse),
              ),
              TextButton(
                onPressed: controller.deleteChecked,
                child: Text(
                  t.records.delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  FavoriteMediaPreviewList(
                    mediaType: MediaType.video,
                    tag: controller.childrenControllerTags[0],
                  ),
                  FavoriteMediaPreviewList(
                    mediaType: MediaType.image,
                    tag: controller.childrenControllerTags[1],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
