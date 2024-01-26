import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';
import 'controller.dart';

class FriendButton extends StatefulWidget {
  final UserModel user;

  const FriendButton({
    super.key,
    required this.user,
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
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
            onPressed: _controller.isProcessing
                ? null
                : () {
                    _controller.sendFriendRequest(context);
                  },
            child: Text(t.friend.add_friend),
          );
        case FriendRelationType.pending:
          return FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.outline,
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
            onPressed: null,
            child: Text(t.friend.pending),
          );
        case FriendRelationType.friended:
          return FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.outline,
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
            onPressed: _controller.isProcessing
                ? null
                : () {
                    _controller.unfriend(context);
                  },
            child: Text(t.friend.unfriend),
          );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
