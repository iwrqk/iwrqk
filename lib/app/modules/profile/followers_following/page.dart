import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../data/models/user.dart';
import '../../../global_widgets/user_preview/users_preview_list/controller.dart';
import '../../../global_widgets/user_preview/users_preview_list/widget.dart';

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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(sourceType == UsersSourceType.followers
            ? L10n.of(context).followers
            : L10n.of(context).following),
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
