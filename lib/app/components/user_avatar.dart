import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'network_image.dart';
import '../const/iwara.dart';
import '../data/services/account_service.dart';
import '../data/services/user_service.dart';

class UserAvatar extends StatelessWidget {
  final double? width;
  final double? height;
  final double? aspectRatio;

  UserAvatar({
    super.key,
    this.width,
    this.height,
    this.aspectRatio,
  });

  final UserService _userService = Get.find();
  final AccountService _accountService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NetworkImg(
        imageUrl: !_accountService.isLogin || _userService.user == null
            ? IwaraConst.defaultAvatarUrl
            : _userService.user!.avatarUrl,
        aspectRatio: aspectRatio,
        width: width,
        height: height,
      ),
    );
  }
}
