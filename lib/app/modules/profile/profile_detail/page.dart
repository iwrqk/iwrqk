import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../l10n.dart';
import '../../../core/utils/display_util.dart';
import '../../../data/models/profile.dart';
import '../../../global_widgets/iwr_markdown.dart';
import '../../../global_widgets/iwr_progress_indicator.dart';
import '../../../global_widgets/reloadable_image.dart';

class ProfileDetailPage extends StatelessWidget {
  final ProfileModel profile;

  const ProfileDetailPage({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
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
        title: Text(L10n.of(context).details),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: false,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 25),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => FullScreenAvatar(
                      avatarUrl: profile.user!.avatarUrl,
                    ),
                  );
                },
                child: ClipOval(
                  child: ReloadableImage(
                    imageUrl: profile.user!.avatarUrl,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            Text(
              L10n.of(context).profile_nickname,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
              child: SelectableText(
                profile.user!.name,
              ),
            ),
            Text(
              L10n.of(context).profile_username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
              child: SelectableText(
                "@${profile.user!.username}",
              ),
            ),
            Text(
              L10n.of(context).profile_user_id,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
              child: SelectableText(
                profile.user!.id,
              ),
            ),
            Text(
              L10n.of(context).profile_join_date,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
              child: Text(
                DisplayUtil.getDetailedTime(
                  DateTime.parse(profile.user!.createdAt),
                ),
              ),
            ),
            if (profile.user!.seenAt != null)
              Text(
                L10n.of(context).profile_last_active_time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (profile.user!.seenAt != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                child: Text(
                  DisplayUtil.getDetailedTime(
                    DateTime.parse(profile.user!.seenAt!),
                  ),
                ),
              ),
            Text(
              L10n.of(context).profile_description,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 50),
              child: IwrMarkdown(
                selectable: true,
                data: profile.body.isEmpty
                    ? L10n.of(context).profile_no_description
                    : profile.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenAvatar extends StatelessWidget {
  final String avatarUrl;

  const FullScreenAvatar({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(avatarUrl),
        loadingBuilder: (context, event) => const Center(
          child: IwrProgressIndicator(),
        ),
      ),
    );
  }
}
