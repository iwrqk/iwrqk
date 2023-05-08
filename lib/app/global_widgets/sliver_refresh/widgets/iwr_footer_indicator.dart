import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../l10n.dart';
import '../../../data/enums/state.dart';
import '../../iwr_progress_indicator.dart';

class IwrFooterIndicator extends StatelessWidget {
  final IwrState indicatorState;
  final VoidCallback? loadMore;

  const IwrFooterIndicator(
      {super.key, required this.indicatorState, this.loadMore});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: 15, bottom: 15 + MediaQuery.of(context).padding.bottom),
        child: () {
          switch (indicatorState) {
            case IwrState.loading:
              return SizedBox(
                width: 24,
                height: 24,
                child: IwrProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(CupertinoColors.inactiveGray),
                  strokeWidth: 2,
                ),
              );
            case IwrState.fail:
              return GestureDetector(
                onTap: loadMore,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    FaIcon(
                      FontAwesomeIcons.circleExclamation,
                      color: CupertinoColors.systemRed,
                    ),
                    Text(
                      L10n.of(context).error_retry,
                      style: TextStyle(
                          fontSize: 12, color: CupertinoColors.inactiveGray),
                    )
                  ]),
                ),
              );
            case IwrState.noMore:
              return FaIcon(
                FontAwesomeIcons.boxArchive,
                color: CupertinoColors.inactiveGray,
              );
            default:
              return Container();
          }
        }(),
      ),
    );
  }
}
