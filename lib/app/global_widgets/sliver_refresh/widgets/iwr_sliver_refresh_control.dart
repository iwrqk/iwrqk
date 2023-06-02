import 'package:flutter/cupertino.dart';

import '../../iwr_icon_progress_indicator.dart';
import '../../iwr_progress_indicator.dart';

class IwrSliverRefreshControl extends StatelessWidget {
  const IwrSliverRefreshControl({Key? key, this.onRefresh}) : super(key: key);

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      builder: (
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent,
      ) {
        double progress = pulledExtent / refreshTriggerPullDistance;

        if (refreshState == RefreshIndicatorMode.refresh) {
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
        } else if (
            refreshState == RefreshIndicatorMode.drag ||
            refreshState == RefreshIndicatorMode.armed) {
          if (refreshState == RefreshIndicatorMode.done ||
              refreshState == RefreshIndicatorMode.refresh ||
              refreshState == RefreshIndicatorMode.armed) {
            progress = 1;
          }

          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 36,
                height: 36,
                child: IwrIconProgressIndicator(
                  value: progress,
                  valueColor: const AlwaysStoppedAnimation(
                      CupertinoColors.inactiveGray),
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      onRefresh: onRefresh,
      refreshTriggerPullDistance: 100,
    );
  }
}
