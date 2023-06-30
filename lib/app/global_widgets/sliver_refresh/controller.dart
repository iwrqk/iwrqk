import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../core/utils/log_util.dart';
import '../../data/enums/result.dart';
import '../../data/enums/state.dart';
import '../../data/services/account_service.dart';

abstract class SliverRefreshController<T> extends GetxController
    with StateMixin {
  final AccountService _accountService = Get.find();
  late bool _requireLogin;

  int _currentPage = 0;
  bool _noMore = false;

  final RxList<T> _data = <T>[].obs;

  List<T> get data => _data;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
  }

  void init(bool requireLogin) {
    _requireLogin = requireLogin;
    if (!_accountService.isLogin && _requireLogin) {
      change(IwrState.requireLogin, status: RxStatus.success());
    } else {
      refreshData(showSplash: true, showFooter: false);
    }
  }

  Future<void> refreshData({
    showSplash = false,
    showFooter = true,
    showFooterAtFail = false,
  }) async {
    _noMore = false;
    _currentPage = 0;
    _data.value = [];
    await loadData(
      showSplash: showSplash,
      showFooter: showFooter,
      showFooterAtFail: showFooterAtFail,
    );
  }

  Future<GroupResult<T>> getNewData(int currentPage);

  Future<void> loadData({
    showSplash = false,
    showFooter = true,
    showFooterAtFail = false,
  }) async {
    if (showSplash) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        change(IwrState.none, status: RxStatus.loading());
      });
    } else if (showFooter) {
      change(IwrState.loading, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.success());
    }

    try {
      GroupResult<T> result = await getNewData(_currentPage);

      List<T> newData = result.results;
      int count = result.count;

      if (newData.isNotEmpty) {
        data.addAll(newData);
        _currentPage++;

        if (data.length >= count) {
          _noMore = true;
          change(IwrState.noMore, status: RxStatus.success());
        } else {
          change(IwrState.none, status: RxStatus.success());
        }
      } else {
        if (showSplash) {
          change(IwrState.none, status: RxStatus.empty());
        } else if (showFooter) {
          change(IwrState.noMore, status: RxStatus.success());
        }
      }
    } catch (e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);

      if (showSplash) {
        change(IwrState.none, status: RxStatus.error(e.toString()));
      } else if (showFooter || showFooterAtFail) {
        showToast(e.toString());
        change(IwrState.fail, status: RxStatus.success());
      }
    }
  }

  void reachBottom() {
    if (data.isNotEmpty && !_noMore) {
      loadData();
    }
  }

  Future<void> footerLoadMore() async {
    if (data.isNotEmpty) {
      return loadData();
    } else {
      return refreshData();
    }
  }
}
