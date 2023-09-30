import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/media/media.dart';
import '../../../global_widgets/sliver_refresh/controller.dart';
import '../normal_search_result/controller.dart';
import 'repository.dart';

class SearchResultMediaPreviewListController
    extends SliverRefreshController<MediaModel> {
  final SearchResultMediaPreviewListRepository repository =
      SearchResultMediaPreviewListRepository();

  final ScrollController scrollController = ScrollController();

  late MediaType _type;
  late String _keyword;

  void initConfig(MediaType type, String keyword,
      NormalSearchResultController parentController) {
    _type = type;
    _keyword = keyword;

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          MediaQuery.of(Get.context!).size.height / 2) {
        parentController.showToTopButton = true;
      } else {
        parentController.showToTopButton = false;
      }
    });
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> resetKeyword(String keyword) async {
    _keyword = keyword;
    if (scrollController.hasClients) {
      scrollController.position.moveTo(0);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshData(showSplash: true, showFooter: false);
    });
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    return repository.getSearchResults(
      currentPage: currentPage,
      type: _type,
      keyword: _keyword,
    );
  }
}
