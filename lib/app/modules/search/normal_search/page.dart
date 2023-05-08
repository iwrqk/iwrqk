import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../routes/pages.dart';
import 'controller.dart';

class NormalSearchPage extends GetView<NormalSearchController> {
  const NormalSearchPage({super.key});

  AlertDialog _buildConfirmDialog(BuildContext context,
      {required String title,
      required String content,
      required Function() onConfirm}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      actions: [
        CupertinoButton(
          onPressed: onConfirm,
          child: Text(
            L10n.of(context).confirm,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryClip(BuildContext context, int index) {
    String keyword = controller.searchHistoryList[index].keyword;
    return GestureDetector(
      onTap: () {
        String currentText = controller.searchEditingController.text;
        if (currentText.isEmpty || currentText == keyword) {
          controller.searchEditingController.text = keyword;
        } else {
          controller.searchEditingController.text += " $keyword";
        }
        currentText = controller.searchEditingController.text;
        controller.showSearchSuffix = true;
        controller.searchFocusNode.requestFocus();
        controller.searchEditingController.selection =
            TextSelection.fromPosition(
                TextPosition(offset: currentText.length));
      },
      onLongPress: () {
        Get.dialog(
          _buildConfirmDialog(
            context,
            title: L10n.of(context).confirm,
            content: L10n.of(context).message_search_history_delete_confirm,
            onConfirm: () async {
              await controller.deleteSearchHistoryItem(index);
              Get.back();
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          keyword,
          style: TextStyle(height: 1),
        ),
      ),
    );
  }

  PreferredSize _buildAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          kTextTabBarHeight + MediaQuery.of(context).padding.top),
      child: Container(
        height: kTextTabBarHeight + MediaQuery.of(context).padding.top,
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: controller.searchFocusNode,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: controller.searchEditingController,
                        decoration: null,
                        onChanged: controller.onSearchTextChanged,
                        onSubmitted: (value) {
                          if (value.isEmpty) return;
                          controller.addSearchHistoryItem(value);
                          Get.toNamed(AppRoutes.normalSearchResult,
                              arguments: value);
                        },
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              controller.clearSearchText();
                            },
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        visible: controller.showSearchSuffix,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                String keyword = controller.searchEditingController.text;
                if (keyword.isEmpty) return;
                controller.addSearchHistoryItem(keyword);
                Get.toNamed(AppRoutes.normalSearchResult, arguments: keyword);
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
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: false,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    L10n.of(context).user_history,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: controller.searchHistoryList.length >
                        controller.maxExpandedClipsCount,
                    child: GestureDetector(
                      onTap: controller.toggleClipsExpanded,
                      child: Text(
                        controller.clipsExpanded
                            ? L10n.of(context).collapse
                            : L10n.of(context).expand,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            textBaseline: TextBaseline.ideographic),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (controller.searchHistoryList.isNotEmpty)
              Wrap(
                children: List.generate(
                  controller.clipsExpanded
                      ? controller.searchHistoryList.length
                      : controller.maxExpandedClipsCount,
                  (index) => Padding(
                    padding: EdgeInsets.all(5),
                    child: _buildHistoryClip(context, index),
                  ),
                ),
              ),
            if (controller.searchHistoryList.isEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: FaIcon(
                  FontAwesomeIcons.boxArchive,
                  size: 50,
                  color: Colors.grey,
                ),
              )
            else
              MaterialButton(
                onPressed: () {
                  Get.dialog(
                    _buildConfirmDialog(
                      context,
                      title: L10n.of(context).confirm,
                      content: L10n.of(context)
                          .message_search_history_delete_all_confirm,
                      onConfirm: () async {
                        await controller.clearSearchHistoryList();
                        Get.back();
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      L10n.of(context).search_history_delete_all,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
