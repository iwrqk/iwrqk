import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../buttons/follow_button/widget.dart';
import '../buttons/friend_button/widget.dart';
import '../network_image.dart';

class UserPreview extends StatelessWidget {
  final UserModel user;
  final bool showFollowButton;
  final bool showFriendButton;
  final Widget? customButton;

  const UserPreview({
    super.key,
    required this.user,
    this.showFollowButton = false,
    this.showFriendButton = false,
    this.customButton,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed("/profile?userName=${user.username}");
      },
      child: ListTile(
        leading: ClipOval(
          child: NetworkImg(
            imageUrl: user.avatarUrl,
            width: 50,
            height: 50,
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontSize: 17.5,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          '@${user.username}',
          style: TextStyle(
            fontSize: 12.5,
            color: Theme.of(context).colorScheme.outline,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFollowButton) FollowButton(user: user),
            if (showFriendButton) FriendButton(user: user),
            if (customButton != null) customButton!,
          ],
        ),
      ),
    );
  }
}
