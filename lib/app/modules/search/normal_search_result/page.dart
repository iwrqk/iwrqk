import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../global_widgets/tab_indicator.dart';
import '../../../global_widgets/user_preview/users_preview_list/widget.dart';
import '../normal_search/controller.dart';
import 'controller.dart';
import '../search_result_media_preview_list/widget.dart';

class NormalSearchResultPage extends GetView<NormalSearchResultController> {
  NormalSearchResultPage({Key? key}) : super(key: key);

  final NormalSearchController _searchController = Get.find();

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
      alignment: Alignment.centerLeft,
      child: Row(children: [
        TabBar(
          controller: controller.tabController,
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          indicator: TabIndicator(context),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: L10n.of(context).videos),
            Tab(text: L10n.of(context).images),
            Tab(text: L10n.of(context).users),
          ],
        ),
      ]),
    );
  }

  PreferredSize _buildAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          kTextTabBarHeight + MediaQuery.of(context).padding.top),
      child: Container(
        height: kTextTabBarHeight + MediaQuery.of(context).padding.top,
        color: Theme.of(context).canvasColor,
        padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: controller.searchFocusNode,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: controller.searchEditingController,
                        decoration: null,
                        onChanged: controller.onSearchTextChanged,
                        onSubmitted: (value) {
                          if (value.isEmpty) return;
                          _searchController.addSearchHistoryItem(value);
                          controller.keyword = value;
                          controller.resetKeyword();
                        },
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.showSearchSuffix,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              controller.clearSearchText();
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                String keyword = controller.searchEditingController.text;
                if (keyword.isEmpty) return;
                _searchController.addSearchHistoryItem(keyword);
                controller.keyword = keyword;
                controller.resetKeyword();
              },
              child: AutoSizeText(
                L10n.of(context).search,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
    return Obx(
      () => Scaffold(
        appBar: _buildAppbar(context),
        floatingActionButton: controller.showToTopButton
            ? FloatingActionButton(
                onPressed: controller.jumpToTop,
                child: const FaIcon(FontAwesomeIcons.arrowUp),
              )
            : null,
        body: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SearchResultMediaPreviewList(
                      type: MediaType.video,
                      initKeyword: controller.keyword,
                      tag: controller.childrenMediaControllerTags[0],
                    ),
                    SearchResultMediaPreviewList(
                      type: MediaType.image,
                      initKeyword: controller.keyword,
                      tag: controller.childrenMediaControllerTags[1],
                    ),
                    UsersPreviewList(
                      sourceType: UsersSourceType.search,
                      sortSetting:
                          UsersSortSetting(keyword: controller.keyword),
                      tag: controller.childUsersControllerTag,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
