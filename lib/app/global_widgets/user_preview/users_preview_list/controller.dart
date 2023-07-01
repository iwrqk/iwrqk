import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../data/models/user.dart';
import '../../../modules/search/normal_search_result/controller.dart';
import '../../sliver_refresh/controller.dart';
import 'repository.dart';

class UsersPreviewListController extends SliverRefreshController<UserModel> {
  final UsersPreviewListRepository repository = UsersPreviewListRepository();

  ScrollController scrollController = ScrollController();

  late UsersSortSetting _sortSetting;
  late UsersSourceType _sourceType;

  bool initializated = false;

  void initConfig(
      UsersSortSetting sortSetting, UsersSourceType sourceType, bool isSearch) {
    _sortSetting = sortSetting;
    _sourceType = sourceType;

    initializated = true;

    if (isSearch) {
      NormalSearchResultController parentController = Get.find();

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            MediaQuery.of(Get.context!).size.height / 2) {
          parentController.showToTopButton = true;
        } else {
          parentController.showToTopButton = false;
        }
      });
    }
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> resetKeyword(String keyword) async {
    if (!initializated) return;

    _sortSetting.keyword = keyword;
    scrollController.position.moveTo(0);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshData(showSplash: true, showFooter: false).then((value) => null);
    });
  }

  @override
  Future<GroupResult<UserModel>> getNewData(int currentPage) {
    return repository.getUsers(
      currentPage: currentPage,
      sortSetting: _sortSetting,
      sourceType: _sourceType,
    );
  }
}
