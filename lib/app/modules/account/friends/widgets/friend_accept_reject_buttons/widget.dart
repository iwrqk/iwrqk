import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../../data/models/user.dart';
import 'controller.dart';

class FriendAcceptRejectButtons extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onChanged;

  const FriendAcceptRejectButtons({
    super.key,
    required this.user,
    this.onChanged,
  });

  @override
  State<FriendAcceptRejectButtons> createState() =>
      _FriendAcceptRejectButtonsState();
}

class _FriendAcceptRejectButtonsState extends State<FriendAcceptRejectButtons>
    with AutomaticKeepAliveClientMixin {
  late FriendAcceptRejectButtonsController _controller;

  @override
  void initState() {
    super.initState();
    Get.create(() => FriendAcceptRejectButtonsController());
    _controller = Get.find();
    _controller.init(widget.user, widget.onChanged);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(
      () => Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: _controller.isProcessing ? null : Colors.red,
              side: _controller.isProcessing
                  ? null
                  : const BorderSide(color: Colors.red),
            ),
            onPressed: _controller.isProcessing ? null : _controller.reject,
            child: Text(
              t.friend.reject,
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: _controller.isProcessing ? null : _controller.accpect,
            child: Text(
              t.friend.accept,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
