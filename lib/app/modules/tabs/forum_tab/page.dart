import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../core/utils/display_util.dart';
import '../../../data/models/forum/channel.dart';
import '../../../global_widgets/iwr_progress_indicator.dart';
import '../../../global_widgets/reloadable_image.dart';
import '../../../global_widgets/sliver_refresh/widgets/iwr_sliver_refresh_control.dart';
import '../../../routes/pages.dart';
import 'controller.dart';

class ForumTabPage extends GetView<ForumTabController> {
  final String tabTag;

  const ForumTabPage({super.key, required this.tabTag});

  Widget _buildChannelPreview(
    BuildContext context, {
    required ChannelModel channel,
  }) {
    return Card(
      color: Theme.of(context).canvasColor,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.channel, arguments: {
            'channelName': channel.id,
            'channelDisplayName': _getChannelTitle(context, channel.id)
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 30,
                      child: Center(
                        child: FaIcon(
                          _getChannelIcon(channel.id),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getChannelTitle(context, channel.id),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      Text(
                        L10n.of(context).channel_label(
                          DisplayUtil.compactBigNumber(channel.numThreads),
                          DisplayUtil.compactBigNumber(channel.numPosts),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
              ListTile(
                leading: ClipOval(
                  child: ReloadableImage(
                    imageUrl: channel.lastThread.user.avatarUrl,
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  channel.lastThread.title,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                subtitle: Text(
                  channel.lastThread.user.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadFailWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                controller.refreshData(showSplash: true);
              },
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: Theme.of(context).primaryColor,
                  size: 42,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  IconData _getChannelIcon(String channelTitle) {
    switch (channelTitle) {
      case "announcements":
        return FontAwesomeIcons.bullhorn;
      case "feedback":
        return FontAwesomeIcons.solidCommentDots;
      case "general":
        return FontAwesomeIcons.solidComments;
      case "guides":
        return FontAwesomeIcons.bookOpenReader;
      case "questions":
        return FontAwesomeIcons.solidCircleQuestion;
      case "requests":
        return FontAwesomeIcons.solidLightbulb;
      case "sharing":
        return FontAwesomeIcons.solidShareFromSquare;
      case "support":
        return FontAwesomeIcons.userShield;
      default:
        return FontAwesomeIcons.question;
    }
  }

  String _getChannelTitle(BuildContext context, String channelTitle) {
    switch (channelTitle) {
      case "announcements":
        return L10n.of(context).channel_announcements;
      case "feedback":
        return L10n.of(context).channel_feedback;
      case "general":
        return L10n.of(context).channel_general;
      case "guides":
        return L10n.of(context).channel_guides;
      case "questions":
        return L10n.of(context).channel_questions;
      case "requests":
        return L10n.of(context).channel_requests;
      case "sharing":
        return L10n.of(context).channel_sharing;
      case "support":
        return L10n.of(context).channel_support;
      default:
        return channelTitle;
    }
  }

  Widget _buildDataWidget(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        IwrSliverRefreshControl(
          onRefresh: controller.refreshData,
        ),
        if (controller.adminChannelModels.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, bottom: 5),
                  child: Text(
                    L10n.of(context).channel_administration,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        SliverList(
          delegate: SliverChildListDelegate(
            controller.adminChannelModels
                .map(
                  (channel) => _buildChannelPreview(
                    context,
                    channel: channel,
                  ),
                )
                .toList(),
          ),
        ),
        if (controller.globalChannelModels.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, bottom: 5),
                  child: Text(
                    L10n.of(context).channel_global,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 10),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              controller.globalChannelModels
                  .map(
                    (channel) => _buildChannelPreview(
                      context,
                      channel: channel,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return Scaffold(
          body: _buildDataWidget(context),
        );
      },
      onError: (error) {
        return Scaffold(
          body: _buildLoadFailWidget(context, error!),
        );
      },
      onLoading: const Scaffold(
        body: Center(
          child: IwrProgressIndicator(),
        ),
      ),
    );
  }
}
