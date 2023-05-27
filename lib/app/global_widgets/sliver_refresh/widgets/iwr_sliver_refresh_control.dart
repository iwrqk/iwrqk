import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide RefreshCallback;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../iwr_progress_indicator.dart';

class IwrSliverRefreshControl extends StatelessWidget {
  const IwrSliverRefreshControl({Key? key, this.onRefresh}) : super(key: key);

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    bool refreshing = false;

    return CupertinoSliverRefreshControl(
      builder: (BuildContext context,
          RefreshIndicatorMode refreshState,
          double pulledExtent,
          double refreshTriggerPullDistance,
          double refreshIndicatorExtent) {
        double progress = pulledExtent / refreshTriggerPullDistance;

        if (refreshState == RefreshIndicatorMode.refresh || refreshing) {
          return const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: IwrProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(CupertinoColors.inactiveGray),
                    strokeWidth: 2,
                  )),
            ),
          );
        } else if (refreshState == RefreshIndicatorMode.drag ||
            refreshState == RefreshIndicatorMode.armed) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: progress,
                  valueColor: const AlwaysStoppedAnimation(
                      CupertinoColors.inactiveGray),
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        } else if (refreshState == RefreshIndicatorMode.done) {
          return const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: FaIcon(
                FontAwesomeIcons.check,
                color: CupertinoColors.inactiveGray,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      onRefresh: () async {
        refreshing = true;
        await onRefresh?.call();
        refreshing = false;
      },
      refreshTriggerPullDistance: 100,
    );
  }
}
