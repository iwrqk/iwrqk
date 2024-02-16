import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Translations;
import 'package:iwrqk/i18n/strings.g.dart';

import '../../routes/pages.dart';
import '../load_empty.dart';
import '../load_fail.dart';
import 'controller.dart';

class IwrRefresh<T> extends StatefulWidget {
  final IwrRefreshController<T> controller;
  final Widget Function(List<T> data, ScrollController? scrollController)
      builder;
  final ScrollController? scrollController;
  final bool requireLogin;
  final int pageSize;
  final bool paginated;

  const IwrRefresh({
    super.key,
    required this.builder,
    required this.controller,
    this.scrollController,
    this.requireLogin = false,
    this.pageSize = 32,
    this.paginated = false,
  });

  @override
  State<StatefulWidget> createState() => _IwrRefreshState<T>();
}

class _IwrRefreshState<T> extends State<IwrRefresh<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.init(
      scrollController: widget.scrollController,
      paginated: widget.paginated,
      requireLogin: widget.requireLogin,
      pageSize: widget.pageSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: widget.controller.refreshController,
      header: const MaterialHeader(),
      onRefresh: () =>
          widget.controller.refreshData(paginated: widget.paginated),
      onLoad: widget.paginated ? null : widget.controller.loadData,
      canRefreshAfterNoMore: true,
      triggerAxis: Axis.vertical,
      child: widget.controller.obx((state) {
        if (state is Map) {
          if (state["state"] == "requireLogin") {
            return _buildRequireLoginWidget();
          } else if (state["state"] == "empty") {
            return const Center(
              child: LoadEmpty(),
            );
          } else if (state["state"] == "fail") {
            return Center(
              child: LoadFail(
                errorMessage: state["msg"],
                onRefresh: () => widget.controller
                    .refreshData(showSplash: true, paginated: widget.paginated),
              ),
            );
          } else if (state["state"] == "loading") {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        return widget.builder(widget.controller.data, widget.scrollController);
      }),
    );
  }

  Widget _buildRequireLoginWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.account.require_login,
            style: const TextStyle(fontSize: 17.5),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            child: Text(
              t.account.login,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }
}
