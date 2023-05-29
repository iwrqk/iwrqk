import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'widgets/thread_preview_list/page.dart';

class ChannelPage extends StatelessWidget {
  ChannelPage({super.key});

  final String channelDisplayName = Get.arguments['channelDisplayName'];
  final String channelName = Get.arguments['channelName'];

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
        title: Text(channelDisplayName),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const FaIcon(
          FontAwesomeIcons.plus,
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ThreadPreviewList(
          channelName: channelName,
        ),
      ),
    );
  }
}
