import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';
import 'controller.dart';

class FriendButton extends StatefulWidget {
  final UserModel user;
  final bool isSmall;
  final EdgeInsets smallPadding;

  const FriendButton({
    super.key,
    required this.user,
    this.isSmall = false,
    this.smallPadding = const EdgeInsets.all(8),
  });

  @override
  State<FriendButton> createState() => _FriendButtonState();
}

class _FriendButtonState extends State<FriendButton>
    with AutomaticKeepAliveClientMixin {
  late FriendButtonController _controller;

  @override
  void initState() {
    super.initState();
    Get.create(() => FriendButtonController());
    _controller = Get.find();
    _controller.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      switch (_controller.relation) {
        case FriendRelationType.unknown:
        case FriendRelationType.none:
          return FilledButton(
            style: widget.isSmall
                ? FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                    minimumSize: Size.zero,
                    padding: widget.smallPadding,
                  )
                : FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                  ),
            onPressed: _controller.isProcessing
                ? null
                : () {
                    _controller.sendFriendRequest(context);
                  },
            child: AutoSizeText(
              t.friend.add_friend,
              maxLines: 1,
            ),
          );
        case FriendRelationType.pending:
          return FilledButton(
            style: widget.isSmall
                ? FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                    minimumSize: Size.zero,
                    padding: widget.smallPadding,
                  )
                : FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                  ),
            onPressed: null,
            child: AutoSizeText(
              t.friend.pending,
              maxLines: 1,
            ),
          );
        case FriendRelationType.friended:
          return FilledButton(
            style: widget.isSmall
                ? FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                    minimumSize: Size.zero,
                    padding: widget.smallPadding,
                  )
                : FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                  ),
            onPressed: _controller.isProcessing
                ? null
                : () {
                    _controller.unfriend(context);
                  },
            child: AutoSizeText(
              t.friend.unfriend,
              maxLines: 1,
            ),
          );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
