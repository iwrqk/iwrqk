import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/models/user.dart';
import 'controller.dart';

class FollowButton extends StatefulWidget {
  final UserModel user;
  final ButtonStyle? outlineStyle;
  final ButtonStyle? filledStyle;
  final Function(String title)? labelBuilder;

  const FollowButton({
    super.key,
    required this.user,
    this.outlineStyle,
    this.filledStyle,
    this.labelBuilder,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with AutomaticKeepAliveClientMixin {
  late FollowButtonController _controller;

  @override
  void initState() {
    super.initState();
    Get.create(() => FollowButtonController());
    _controller = Get.find();
    _controller.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (_controller.isFollowing) {
        return OutlinedButton.icon(
          style: widget.outlineStyle?.copyWith(
                  side: _controller.isProcessing
                      ? null
                      : MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Theme.of(context).primaryColor),
                        )) ??
              OutlinedButton.styleFrom(
                side: _controller.isProcessing
                    ? null
                    : BorderSide(color: Theme.of(context).primaryColor),
              ),
          onPressed:
              _controller.isProcessing ? null : _controller.unfollowUploader,
          icon: const FaIcon(FontAwesomeIcons.check),
          label: widget.labelBuilder != null
              ? widget.labelBuilder!(L10n.of(context).following)
              : Text(
                  L10n.of(context).following,
                ),
        );
      } else {
        return ElevatedButton.icon(
          style: widget.filledStyle,
          onPressed:
              _controller.isProcessing ? null : _controller.followUploader,
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: widget.labelBuilder != null
              ? widget.labelBuilder!(L10n.of(context).follow)
              : Text(
                  L10n.of(context).follow,
                ),
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
