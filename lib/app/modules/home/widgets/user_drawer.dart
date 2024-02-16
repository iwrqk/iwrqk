import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/account_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/pages.dart';
import '../../../components/user_avatar.dart';

class UserDrawer extends StatelessWidget {
  UserService get _userService => Get.find();
  AccountService get _accountService => Get.find();

  const UserDrawer({Key? key}) : super(key: key);

  Widget _buildUserItem(
    BuildContext context, {
    required title,
    required icon,
    required String routeName,
    dynamic arguments,
    bool requireLogin = true,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: MaterialButton(
        onPressed: () {
          if (_accountService.isLogin || !requireLogin) {
            Get.toNamed(routeName, arguments: arguments);
          } else {
            Get.toNamed(AppRoutes.login);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 36,
                      child: Center(
                        child: icon,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(115),
      child: InkWell(
        onTap: () {
          if (_accountService.isLogin) {
            Get.toNamed("/profile?userName=${_userService.user!.username}");
          } else {
            Get.toNamed(AppRoutes.login);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    ClipOval(
                      child: UserAvatar(
                        width: 48,
                        height: 48,
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            !_accountService.isLogin ||
                                    _userService.user == null
                                ? t.account.login
                                : _userService.user!.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_accountService.isLogin) {
                    _accountService.logout();
                    Get.offNamedUntil(AppRoutes.splash, (route) => false);
                  } else {
                    Get.toNamed(AppRoutes.login);
                  }
                },
                icon: const Icon(
                  Icons.logout,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildUserCard(context)),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildUserItem(
                      context,
                      title: t.user.friends,
                      icon: const Icon(
                        Icons.people,
                        size: 24,
                      ),
                      routeName: AppRoutes.friends,
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.blocked_tags,
                      icon: const Icon(
                        Icons.block,
                        size: 24,
                      ),
                      routeName: AppRoutes.blockedTags,
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.following,
                      icon: const Icon(
                        Icons.subscriptions,
                        size: 24,
                      ),
                      routeName:
                          "/followersFollowing?type=following&userId=${_userService.user?.id}",
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.history,
                      icon: const Icon(
                        Icons.history,
                        size: 24,
                      ),
                      routeName: AppRoutes.history,
                      requireLogin: false,
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.downloads,
                      icon: const Icon(
                        Icons.download,
                        size: 24,
                      ),
                      routeName: AppRoutes.downloads,
                      requireLogin: false,
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.favorites,
                      icon: const Icon(
                        Icons.favorite,
                        size: 24,
                      ),
                      routeName: AppRoutes.favorites,
                    ),
                    _buildUserItem(
                      context,
                      title: t.user.playlists,
                      icon: const Icon(
                        Icons.playlist_play,
                        size: 24,
                      ),
                      routeName:
                          "/playlistsPreview?userId=${_userService.user?.id}&requireMyself=true",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: _buildUserItem(
                        context,
                        title: t.user.settings,
                        icon: const Icon(
                          Icons.settings,
                          size: 24,
                        ),
                        routeName: AppRoutes.settings,
                        requireLogin: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
