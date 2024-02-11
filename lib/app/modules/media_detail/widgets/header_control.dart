import 'package:floating/floating.dart';
import 'package:flutter/material.dart';

import '../../../components/plugin/pl_player/index.dart';
import '../controller.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    this.floating,
    super.key,
  });
  final PlPlayerController? controller;
  final MediaDetailController? videoDetailCtr;
  final Floating? floating;

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
