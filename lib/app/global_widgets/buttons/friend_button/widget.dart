import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';
import 'controller.dart';

class FriendButtonWidget extends StatefulWidget {
  final UserModel user;
  final ButtonStyle? outlineStyle;
  final ButtonStyle? filledStyle;
  final bool onlyIcon;

  const FriendButtonWidget({
    super.key,
    required this.user,
    this.outlineStyle,
    this.filledStyle,
    this.onlyIcon = false,
  });

  @override
  State<FriendButtonWidget> createState() => _FriendButtonWidgetState();
}

class _FriendButtonWidgetState extends State<FriendButtonWidget>
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
          return widget.onlyIcon
              ? ElevatedButton(
                  style: widget.filledStyle,
                  onPressed: _controller.isProcessing
                      ? null
                      : () {
                          _controller.sendFriendRequest(context);
                        },
                  child: const FaIcon(
                    FontAwesomeIcons.userGroup,
                  ))
              : ElevatedButton.icon(
                  style: widget.filledStyle,
                  onPressed: _controller.isProcessing
                      ? null
                      : () {
                          _controller.sendFriendRequest(context);
                        },
                  icon: const FaIcon(FontAwesomeIcons.userGroup),
                  label: Text(
                    L10n.of(context).friend_add,
                  ),
                );
        case FriendRelationType.pending:
          return widget.onlyIcon
              ? ElevatedButton(
                  style: widget.filledStyle,
                  onPressed: null,
                  child: const FaIcon(
                    FontAwesomeIcons.solidClock,
                  ),
                )
              : ElevatedButton.icon(
                  style: widget.filledStyle,
                  onPressed: null,
                  icon: const FaIcon(
                    FontAwesomeIcons.solidClock,
                  ),
                  label: Text(
                    L10n.of(context).friend_pending,
                  ),
                );
        case FriendRelationType.friended:
          return widget.onlyIcon
              ? OutlinedButton(
                  style: widget.outlineStyle?.copyWith(
                          side: _controller.isProcessing
                              ? null
                              : MaterialStateProperty.all<BorderSide>(
                                  BorderSide(
                                      color: Theme.of(context).primaryColor),
                                )) ??
                      OutlinedButton.styleFrom(
                        side: _controller.isProcessing
                            ? null
                            : BorderSide(color: Theme.of(context).primaryColor),
                      ),
                  onPressed: _controller.isProcessing
                      ? null
                      : () {
                          _controller.unfriend(context);
                        },
                  child: const FaIcon(FontAwesomeIcons.userSlash),
                )
              : OutlinedButton.icon(
                  style: widget.outlineStyle?.copyWith(
                          side: _controller.isProcessing
                              ? null
                              : MaterialStateProperty.all<BorderSide>(
                                  BorderSide(
                                      color: Theme.of(context).primaryColor),
                                )) ??
                      OutlinedButton.styleFrom(
                        side: _controller.isProcessing
                            ? null
                            : BorderSide(color: Theme.of(context).primaryColor),
                      ),
                  onPressed: _controller.isProcessing
                      ? null
                      : () {
                          _controller.unfriend(context);
                        },
                  icon: const FaIcon(FontAwesomeIcons.check),
                  label: Text(
                    L10n.of(context).friended,
                  ),
                );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
