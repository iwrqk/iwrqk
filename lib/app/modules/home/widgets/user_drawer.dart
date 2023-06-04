import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/services/account_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/pages.dart';
import 'user_avatar.dart';

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
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Theme.of(context).brightness == Brightness.light
            ? ThemeData.light().highlightColor
            : ThemeData.dark().highlightColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: () {
            if (_accountService.isLogin || !requireLogin) {
              Get.toNamed(routeName, arguments: arguments);
            } else {
              Get.toNamed(AppRoutes.login);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 35,
                        child: Center(
                          child: icon,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 15,
                ),
              ],
            ),
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
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  if (_accountService.isLogin) {
                    Get.toNamed(
                      AppRoutes.profile,
                      arguments: _userService.user!.username,
                      preventDuplicates: true,
                    );
                  } else {
                    Get.toNamed(AppRoutes.login);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: UserAvatar(
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: AutoSizeText(
                                      !_accountService.isLogin ||
                                              _userService.user == null
                                          ? L10n.of(context).login
                                          : _userService.user!.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: const FaIcon(
                            FontAwesomeIcons.chevronRight,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _buildUserItem(
                      context,
                      title: L10n.of(context).user_friends,
                      icon: const FaIcon(
                        FontAwesomeIcons.userGroup,
                        size: 25,
                      ),
                      routeName: AppRoutes.friends,
                    ),
                    _buildUserItem(
                      context,
                      title: L10n.of(context).user_history,
                      icon: const FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                        size: 25,
                      ),
                      routeName: AppRoutes.history,
                      requireLogin: false,
                    ),
                    _buildUserItem(
                      context,
                      title: L10n.of(context).user_downloads,
                      icon: const FaIcon(
                        FontAwesomeIcons.download,
                        size: 25,
                      ),
                      routeName: AppRoutes.downloads,
                      requireLogin: false,
                    ),
                    _buildUserItem(
                      context,
                      title: L10n.of(context).user_favorites,
                      icon: const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        size: 25,
                      ),
                      routeName: AppRoutes.favorites,
                    ),
                    _buildUserItem(
                      context,
                      title: L10n.of(context).user_playlists,
                      icon: const FaIcon(
                        FontAwesomeIcons.list,
                        size: 25,
                      ),
                      routeName: AppRoutes.playlistsPreview,
                      arguments: {
                        'requireMyself': true,
                        'userId': _userService.user?.id,
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: _buildUserItem(
                        context,
                        title: L10n.of(context).user_settings,
                        icon: const FaIcon(
                          FontAwesomeIcons.gear,
                          size: 25,
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
