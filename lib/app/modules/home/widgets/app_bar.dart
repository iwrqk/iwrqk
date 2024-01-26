import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/network_image.dart';
import '../../../data/services/account_service.dart';
import '../../../data/services/user_service.dart';
import '../../search/page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final VoidCallback onAvatarTap;

  HomeAppBar({
    super.key,
    required this.onAvatarTap,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  final UserService _userService = Get.find();
  final AccountService _accountService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 56,
      padding: EdgeInsets.only(
        left: 8,
        right: 12,
        bottom: 8,
        top: MediaQuery.of(context).padding.top + 4,
      ),
      child: Obx(
        () => Row(
          children: [
            if (!_accountService.isLogin || _userService.user == null) ...[
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface),
                onPressed: onAvatarTap,
                icon: const Icon(Icons.person),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: ClipOval(
                    child: NetworkImg(
                      width: 40,
                      height: 40,
                      imageUrl: _userService.user!.avatarUrl,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 6),
            const Expanded(child: SearchPage()),
          ],
        ),
      ),
    );
  }
}
