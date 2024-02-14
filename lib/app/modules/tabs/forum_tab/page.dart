import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/load_fail.dart';
import '../../../components/network_image.dart';
import '../../../data/models/forum/channel.dart';
import '../../../routes/pages.dart';
import '../../../utils/display_util.dart';
import 'controller.dart';

class ForumTabPage extends GetView<ForumTabController> {
  final String tabTag;

  const ForumTabPage({super.key, required this.tabTag});

  Widget _buildChannelPreview(
    BuildContext context, {
    required ChannelModel channel,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.channel, arguments: {
            'channelName': channel.id,
            'channelDisplayName': _getChannelTitle(context, channel.id)
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 32,
                      child: Center(
                        child: Icon(
                          _getChannelIcon(channel.id),
                          color: Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      Text(
                        t.channel.label(
                          numThread:
                              DisplayUtil.compactBigNumber(channel.numThreads),
                          numPosts:
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
                    child: NetworkImg(
                      imageUrl: channel.lastThread!.user.avatarUrl,
                      width: 42,
                      height: 42,
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

  IconData _getChannelIcon(String channelTitle) {
    switch (channelTitle.split("-").first) {
      case "announcements":
        return Icons.campaign;
      case "feedback":
        return Icons.feedback;
      case "general":
        return Icons.forum;
      case "guides":
        return Icons.book;
      case "questions":
        return Icons.question_mark;
      case "requests":
        return Icons.lightbulb;
      case "sharing":
        return Icons.share;
      case "support":
        return Icons.support;
      default:
        return Icons.forum;
    }
  }

  String _getChannelTitle(BuildContext context, String channelTitle) {
    channelTitle = channelTitle.split("-").first;
    switch (channelTitle) {
      case "announcements":
        return t.channel.announcements;
      case "feedback":
        return t.channel.feedback;
      case "general":
        return t.channel.general;
      case "guides":
        return t.channel.guides;
      case "questions":
        return t.channel.questions;
      case "requests":
        return t.channel.requests;
      case "sharing":
        return t.channel.sharing;
      case "support":
        return t.channel.support;
      default:
        return channelTitle[0].toUpperCase() + channelTitle.substring(1);
    }
  }

  String _getGroupTitle(BuildContext context, String groupTitle) {
    groupTitle = groupTitle.split("-").first;
    switch (groupTitle) {
      case "administration":
        return t.channel.administration;
      case "global":
        return t.channel.global;
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
              padding: const EdgeInsets.only(top: 24, left: 16, bottom: 8),
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
    List<Widget> children = [];

    controller.channelModels
        .forEach((String groupTitle, List<ChannelModel> channels) {
      children.addAll(
        _buildGroupChannelsWidget(
            context, _getGroupTitle(context, groupTitle), channels),
      );
    });

    children.add(
      const SliverToBoxAdapter(
        child: SizedBox(height: 16),
      ),
    );

    return EasyRefresh(
      header: const MaterialHeader(),
      onRefresh: () async {
        await controller.refreshData();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        slivers: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.checkFirstLoad();
    return controller.obx(
      (state) {
        return _buildDataWidget(context);
      },
      onError: (error) {
        return Center(
          child: LoadFail(
            errorMessage: error!,
            onRefresh: () {
              controller.refreshData(showSplash: true);
            },
          ),
        );
      },
      onLoading: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
