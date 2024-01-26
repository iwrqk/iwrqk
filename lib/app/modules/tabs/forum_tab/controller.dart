import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/forum/channel.dart';
import '../../../data/providers/api_provider.dart';

class ForumTabController extends GetxController with StateMixin {
  Map<String, List<ChannelModel>> channelModels = {};

  ScrollController scrollController = ScrollController();

  bool firstLoad = true;

  void checkFirstLoad() {
    if (firstLoad) {
      loadData();
      change(null, status: RxStatus.loading());
      firstLoad = false;
    }
  }

  Future<void> refreshData({bool showSplash = false}) async {
    channelModels.clear();
    if (showSplash) {
      change(null, status: RxStatus.loading());
    } else {
      change(null, status: RxStatus.success());
    }
    await loadData();
  }

  Future<void> loadData() async {
    String? message;
    bool success = true;

    await ApiProvider.getForumChannels().then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        for (var item in value.data!) {
          if (channelModels[item.group] == null) {
            channelModels[item.group] = [];
          }
          channelModels[item.group]!.add(item);
        }
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    } else {
      change(null, status: RxStatus.success());
    }
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void scrollToTopRefresh() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    refreshData(showSplash: true);
  }
}
