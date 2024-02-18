import 'package:animations/animations.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../components/load_empty.dart';
import 'controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController _controller = Get.put(SearchController());

  Widget _buildHistoryClip(BuildContext context, int index) {
    String keyword = _controller.searchHistoryList[index].keyword;

    return Material(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      child: InkWell(
        onTap: () {
          String currentText = _controller.searchEditingController.text;
          _controller.searchEditingController.text = keyword;
          currentText = _controller.searchEditingController.text;
          _controller.showSearchSuffix = true;
          _controller.searchFocusNode.requestFocus();
          _controller.searchEditingController.selection =
              TextSelection.fromPosition(
            TextPosition(
              offset: currentText.length,
            ),
          );
        },
        onLongPress: () async {
          HapticFeedback.mediumImpact();
          await _controller.deleteSearchHistoryItem(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            keyword,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Hero(
            tag: 'searchTag',
            child: IconButton(
              onPressed: _controller.submit,
              icon: const Icon(Icons.search, size: 22),
            ),
          ),
          const SizedBox(width: 10)
        ],
        title: TextField(
          autofocus: true,
          focusNode: _controller.searchFocusNode,
          controller: _controller.searchEditingController,
          textInputAction: TextInputAction.search,
          onChanged: _controller.onSearchTextChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 22,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: _controller.clearSearchText,
            ),
          ),
          onSubmitted: (_) => _controller.submit(),
        ),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.user.history,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Visibility(
                    visible: _controller.searchHistoryList.length >
                        _controller.maxExpandedClipsCount,
                    child: TextButton(
                      onPressed: _controller.toggleClipsExpanded,
                      child: Text(
                        _controller.clipsExpanded
                            ? t.common.collapse
                            : t.common.expand,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_controller.searchHistoryList.isNotEmpty)
              Wrap(
                children: List.generate(
                  _controller.clipsExpanded
                      ? _controller.searchHistoryList.length
                      : _controller.maxExpandedClipsCount,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildHistoryClip(context, index),
                  ),
                ),
              ),
            if (_controller.searchHistoryList.isEmpty)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const LoadEmpty(),
              )
            else
              TextButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text(t.search.history.delete),
                      content: Text(t.message.are_you_sure_to_do_that),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            t.notifications.cancel,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _controller.clearSearchHistoryList();
                            Get.back();
                          },
                          child: Text(t.notifications.confirm),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(t.search.history.delete),
              ),
            SizedBox(
              height: Get.height * 0.1,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      openColor: Theme.of(context).colorScheme.background,
      middleColor: Theme.of(context).colorScheme.background,
      closedColor: Theme.of(context).colorScheme.background,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      closedBuilder: (context, action) {
        return SizedBox(
          height: 44,
          child: Material(
            color:
                Theme.of(context).colorScheme.onInverseSurface.withAlpha(255),
            child: InkWell(
              splashColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              onTap: action,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.nav.search,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
      openBuilder: (context, action) => _buildHistoryPage(),
    );
  }
}
