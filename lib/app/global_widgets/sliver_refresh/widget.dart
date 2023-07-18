import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../data/enums/state.dart';
import '../../routes/pages.dart';
import '../iwr_progress_indicator.dart';
import 'controller.dart';
import 'widgets/iwr_footer_indicator.dart';
import 'widgets/iwr_sliver_refresh_control.dart';

class SliverRefresh<T> extends StatefulWidget {
  final SliverRefreshController<T> controller;
  final Widget Function(
      List<T> data, void Function(int index) reachBottomCallback) builder;
  final ScrollController? scrollController;
  final bool requireLogin;
  final bool? primary;

  const SliverRefresh({
    super.key,
    required this.builder,
    required this.controller,
    this.scrollController,
    this.requireLogin = false,
    this.primary,
  });

  @override
  State<StatefulWidget> createState() => _SliverRefreshState<T>();
}

class _SliverRefreshState<T> extends State<SliverRefresh<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.init(widget.requireLogin);
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.obx(
      (state) {
        if (state == IwrState.requireLogin) {
          return _buildRequireLoginWidget();
        }
        return _buildDataWidget(state ?? IwrState.none);
      },
      onError: (error) {
        return _buildFirstLoadFailWidget(error!);
      },
      onLoading: const Center(
        child: IwrProgressIndicator(),
      ),
      onEmpty: const Center(
        child: FaIcon(
          FontAwesomeIcons.boxArchive,
          color: Colors.grey,
          size: 42,
        ),
      ),
    );
  }

  Widget _buildDataWidget(IwrState footerIndicatorState) {
    return CustomScrollView(
      primary: widget.primary,
      controller: widget.scrollController,
      cacheExtent: 150,
      clipBehavior: Clip.none,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        if (!(widget.controller.data.isEmpty &&
            footerIndicatorState == IwrState.fail))
          IwrSliverRefreshControl(
            onRefresh: () async {
              await widget.controller
                  .refreshData(showFooter: false, showFooterAtFail: true);
            },
          ),
        widget.builder(
          widget.controller.data,
          (int index) async {
            if (index == widget.controller.data.length - 1 &&
                footerIndicatorState != IwrState.loading &&
                footerIndicatorState != IwrState.fail) {
              SchedulerBinding.instance
                  .addPostFrameCallback((Duration callback) {
                widget.controller.reachBottom();
              });
            }
          },
        ),
        IwrFooterIndicator(
          indicatorState: footerIndicatorState,
          loadMore: widget.controller.footerLoadMore,
        ),
      ],
    );
  }

  Widget _buildRequireLoginWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: FaIcon(
                  FontAwesomeIcons.userCheck,
                  size: 42,
                  color: Colors.grey,
                ),
              ),
              Text(
                L10n.of(context).message_require_login,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            child: Text(
              L10n.of(context).login,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstLoadFailWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                widget.controller
                    .refreshData(showSplash: true, showFooter: false);
              },
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: Theme.of(context).primaryColor,
                  size: 42,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
