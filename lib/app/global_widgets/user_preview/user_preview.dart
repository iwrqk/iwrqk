import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../../routes/pages.dart';
import '../buttons/follow_button/widget.dart';
import '../buttons/friend_button/widget.dart';
import '../reloadable_image.dart';

class UserPreview extends StatelessWidget {
  final UserModel user;
  final bool showFollowButton;
  final bool showFriendButton;
  final Widget? customButton;

  const UserPreview({
    super.key,
    required this.user,
    this.showFollowButton = true,
    this.showFriendButton = false,
    this.customButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.profile,
            arguments: user.username,
            preventDuplicates: true,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  ClipOval(
                    child: ReloadableImage(
                      imageUrl: user.avatarUrl,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 17.5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            '@${user.username}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showFollowButton) FollowButton(user: user),
            if (showFriendButton) FriendButtonWidget(user: user),
            if (customButton != null) customButton!,
          ],
        ),
      ),
    );
  }
}
