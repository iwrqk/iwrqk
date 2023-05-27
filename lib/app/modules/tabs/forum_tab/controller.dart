import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../data/models/forum/channel.dart';
import '../../../data/providers/network/api_provider.dart';

class ForumTabController extends GetxController with StateMixin {
  List<ChannelModel> adminChannelModels = [];
  List<ChannelModel> globalChannelModels = [];

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadData();
    change(null, status: RxStatus.loading());
  }

  Future<void> refreshData({bool showSplash = false}) async {
    adminChannelModels.clear();
    globalChannelModels.clear();
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
          if (item.group == "global") {
            globalChannelModels.add(item);
          } else {
            adminChannelModels.add(item);
          }
        }
      }
    });

    if (!success) {
      showToast(message!);
      change(null, status: RxStatus.error(message!));
      return;
    } else {
      change(null, status: RxStatus.success());
    }
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void scrollToTopRefresh() {
    if (scrollController.hasClients) {
      scrollController.animateTo(-100,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }
}
