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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
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
              if (channel.lastThread != null)
                ListTile(
                  leading: ClipOval(
                    child: ReloadableImage(
                      imageUrl: channel.lastThread!.user.avatarUrl,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  title: Text(
                    channel.lastThread!.title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  subtitle: Text(
                    channel.lastThread!.user.name,
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
    switch (channelTitle.split("-").first) {
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
    channelTitle = channelTitle.split("-").first;
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
        return channelTitle[0].toUpperCase() + channelTitle.substring(1);
    }
  }

  String _getGroupTitle(BuildContext context, String groupTitle) {
    groupTitle = groupTitle.split("-").first;
    switch (groupTitle) {
      case "administration":
        return L10n.of(context).channel_administration;
      case "global":
        return L10n.of(context).channel_global;
      default:
        return groupTitle[0].toUpperCase() + groupTitle.substring(1);
    }
  }

  List<Widget> _buildGroupChannelsWidget(BuildContext context,
      String groupTitle, List<ChannelModel> channelModels) {
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 15, bottom: 5),
              child: Text(
                groupTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate(
          channelModels
              .map(
                (channel) => _buildChannelPreview(
                  context,
                  channel: channel,
                ),
              )
              .toList(),
        ),
      ),
    ];
  }

  Widget _buildDataWidget(BuildContext context) {
    List<Widget> children = [
      IwrSliverRefreshControl(
        onRefresh: controller.refreshData,
      ),
    ];

    controller.channelModels
        .forEach((String groupTitle, List<ChannelModel> channels) {
      children.addAll(_buildGroupChannelsWidget(
          context, _getGroupTitle(context, groupTitle), channels));
    });

    return CustomScrollView(
      controller: controller.scrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.checkFirstLoad();
    return controller.obx(
      (state) {
        return SafeArea(
          child: _buildDataWidget(context),
        );
      },
      onError: (error) {
        return _buildLoadFailWidget(context, error!);
      },
      onLoading: const Center(
        child: IwrProgressIndicator(),
      ),
    );
  }
}
