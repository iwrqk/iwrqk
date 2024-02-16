import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../const/widget.dart';
import '../../data/enums/result.dart';
import '../../data/services/account_service.dart';
import '../../utils/log_util.dart';

abstract class IwrRefreshController<T> extends GetxController with StateMixin {
  ScrollController? _scrollController;

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final AccountService accountService = Get.find();

  bool _pagination = false;
  bool _requireLogin = false;

  RxInt _currentPage = 0.obs;
  int get currentPage => _currentPage.value;
  set currentPage(int value) => _currentPage.value = value;

  int pageSize = WidgetConst.pageLimit;

  int get totalPage => (count / pageSize).ceil();

  final RxInt _count = 0.obs;
  int get count => _count.value;
  set count(int value) => _count.value = value;

  final RxList<T> _data = <T>[].obs;

  List<T> get data => _data;

  void init({
    ScrollController? scrollController,
    required bool paginated,
    required bool requireLogin,
    required int pageSize,
  }) {
    _scrollController = scrollController;
    _pagination = paginated;
    _requireLogin = requireLogin;
    this.pageSize = pageSize;
    refreshData(showSplash: true, paginated: paginated);
  }

  void resetScrollPosition() {
    _scrollController?.hasClients == true &&
            _scrollController?.position.pixels != 0
        ? _scrollController?.position.moveTo(0)
        : _scrollController?.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
  }

  Future<void> refreshData({
    showSplash = false,
    paginated = false,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!accountService.isLogin && _requireLogin) {
        change({"state": "requireLogin"}, status: RxStatus.success());
        return;
      }
      _count.value = 0;
      if (!paginated) {
        _currentPage.value = 0;
      }
      _data.value = [];
      await loadData(
        showSplash: showSplash,
        isRefresh: true,
      );
    });
  }

  Future<GroupResult<T>> getNewData(int currentPage);

  Future<void> loadData({
    showSplash = false,
    isRefresh = false,
  }) async {
    if (showSplash) {
      change({"state": "loading"}, status: RxStatus.success());
    }

    try {
      GroupResult<T> result = await getNewData(currentPage);

      List<T> newData = result.results;
      int count = result.count;

      if (newData.isNotEmpty) {
        data.addAll(newData);
        _count.value = count;
        if (!_pagination) _currentPage.value++;

        if (data.length >= count) {
          endLoading(isRefresh, IndicatorResult.noMore);
          change(null, status: RxStatus.success());
          return;
        }
        change(null, status: RxStatus.success());
      } else {
        if (showSplash) {
          change({"state": "empty"}, status: RxStatus.success());
        }
      }
    } catch (e, stackTrace) {
      LogUtil.warning("Failed to load data", e, stackTrace);

      if (showSplash) {
        change({"state": "fail", "msg": e.toString()},
            status: RxStatus.success());
      } else {
        SmartDialog.showToast(e.toString());
        endLoading(isRefresh, IndicatorResult.fail);
        return;
      }
    }

    endLoading(isRefresh, IndicatorResult.none);
  }

  void endLoading(bool isRefresh, IndicatorResult result) {
    if (!isRefresh) {
      refreshController.finishLoad(result);
    } else {
      refreshController.finishRefresh(result);
      refreshController.resetFooter();
    }

    if (result == IndicatorResult.noMore) {
      refreshController.finishLoad(result);
    }
  }

  void nextPage() {
    if (!_pagination) return;
    if (currentPage < totalPage) {
      _count.value = 0;
      _data.value = [];
      _currentPage++;
      loadData(showSplash: true);
    }
  }

  void previousPage() {
    if (!_pagination) return;
    if (currentPage >= 1) {
      _count.value = 0;
      _data.value = [];
      _currentPage--;
      loadData(showSplash: true);
    }
  }

  void setPage(int page) {
    if (!_pagination) return;
    if (page >= 0 && page <= totalPage) {
      _count.value = 0;
      _data.value = [];
      _currentPage.value = page;
      loadData(showSplash: true);
    }
  }
}
