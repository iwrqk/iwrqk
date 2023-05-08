import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/const/iwara.dart';
import '../../../data/services/account_service.dart';
import '../../../data/services/user_service.dart';
import '../../../global_widgets/reloadable_image.dart';

class UserAvatar extends StatelessWidget {
  double? width;
  double? height;
  double? aspectRatio;

  UserAvatar({
    Key? key,
    this.width,
    this.height,
    this.aspectRatio,
  });

  final UserService _userService = Get.find();
  final AccountService _accountService = Get.find();

  @override
  Widget build(BuildContext context) {
    return ReloadableImage(
      imageUrl: !_accountService.isLogin || _userService.user == null
          ? IwaraConst.defaultAvatarUrl
          : _userService.user!.avatarUrl,
      aspectRatio: aspectRatio,
      width: width,
      height: height,
    );
  }
}
