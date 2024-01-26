import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/user_preview/users_preview_list/controller.dart';
import '../../../components/user_preview/users_preview_list/widget.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../data/models/user.dart';

class FollowersFollowingPage extends StatelessWidget {
  FollowersFollowingPage({super.key});

  final UsersSourceType sourceType = Get.arguments["sourceType"];
  final UserModel parentUserData = Get.arguments["parentUser"];

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => UsersPreviewListController(),
      tag: "${parentUserData.username}_${sourceType.name}",
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(sourceType == UsersSourceType.followers
            ? t.profile.followers
            : t.profile.following),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: UsersPreviewList(
          sortSetting: UsersSortSetting(userId: parentUserData.id),
          sourceType: sourceType,
          tag: "${parentUserData.username}_${sourceType.name}",
        ),
      ),
    );
  }
}
