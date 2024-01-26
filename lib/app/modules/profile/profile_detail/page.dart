import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:photo_view/photo_view.dart';

import '../../../components/iwr_markdown.dart';
import '../../../components/network_image.dart';
import '../../../data/models/profile.dart';
import '../../../utils/display_util.dart';

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
        title: Text(profile.user!.name),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: false,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 48, bottom: 24),
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
                child: NetworkImg(
                  imageUrl: profile.user!.avatarUrl,
                  width: 156,
                  height: 156,
                ),
              ),
            ),
          ),
          Text(
            t.profile.nickname,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
            child: SelectableText(
              profile.user!.name,
            ),
          ),
          Text(
            t.profile.username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
            child: SelectableText(
              "@${profile.user!.username}",
            ),
          ),
          Text(
            t.profile.user_id,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
            child: SelectableText(
              profile.user!.id,
            ),
          ),
          Text(
            t.profile.join_date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
            child: Text(
              DisplayUtil.getDetailedTime(
                DateTime.parse(profile.user!.createdAt),
              ),
            ),
          ),
          if (profile.user!.seenAt != null)
            Text(
              t.profile.last_active_time,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (profile.user!.seenAt != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
              child: Text(
                DisplayUtil.getDetailedTime(
                  DateTime.parse(profile.user!.seenAt!),
                ),
              ),
            ),
          Text(
            t.profile.description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                8, 8, 0, Get.mediaQuery.padding.bottom + 16),
            child: IwrMarkdown(
              selectable: true,
              data: profile.body.isEmpty
                  ? t.profile.no_description
                  : profile.body,
            ),
          ),
        ],
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(avatarUrl),
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
