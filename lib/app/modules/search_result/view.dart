import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../components/media_preview/media_preview_grid/widget.dart';
import '../../components/user_preview/users_preview_list/widget.dart';
import '../../data/enums/types.dart';
import '../../data/models/account/settings/media_search_setting.dart';
import '../../data/models/account/settings/users_sort_setting.dart';
import 'controller.dart';

class SearchResultPage extends GetView<SearchResultController> {
  const SearchResultPage({super.key});

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

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(bottom: 0, top: 4),
      alignment: Alignment.centerLeft,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: tabNameList
            .map((e) => Tab(
                  text: e,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildVidoesTab(BuildContext context) {
    return DefaultTabController(
      length: tabNameList.length,
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              children: List.generate(
                tabNameList.length,
                (index) => MediaPreviewGrid(
                  sourceType: MediaSourceType.search,
                  searchSetting: MediaSearchSettingModel(
                    keyword: controller.keyword,
                    searchType: SearchType.videos,
                    orderType: orderTypeList[index],
                  ),
                  isHorizontal: true,
                  tag: controller.childrenMediaControllerTags[0] +
                      controller.tabTagList[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesTab(BuildContext context) {
    return DefaultTabController(
      length: tabNameList.length,
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              children: List.generate(
                tabNameList.length,
                (index) => MediaPreviewGrid(
                  sourceType: MediaSourceType.search,
                  searchSetting: MediaSearchSettingModel(
                    keyword: controller.keyword,
                    searchType: SearchType.images,
                    orderType: orderTypeList[index],
                  ),
                  isHorizontal: true,
                  tag: controller.childrenMediaControllerTags[1] +
                      controller.tabTagList[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              controller.keyword,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 8),
            color: Theme.of(context).colorScheme.surface,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: controller.tabController,
                tabs: [
                  Tab(text: t.nav.videos),
                  Tab(text: t.nav.images),
                  Tab(text: t.search.users),
                ],
                isScrollable: true,
                indicatorWeight: 0,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
                labelStyle: const TextStyle(fontSize: 13),
                dividerColor: Colors.transparent,
                unselectedLabelColor: Theme.of(context).colorScheme.outline,
                tabAlignment: TabAlignment.start,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildVidoesTab(context),
                _buildImagesTab(context),
                UsersPreviewList(
                  sourceType: UsersSourceType.search,
                  sortSetting: UsersSortSetting(keyword: controller.keyword),
                  tag: controller.childUsersControllerTag,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
