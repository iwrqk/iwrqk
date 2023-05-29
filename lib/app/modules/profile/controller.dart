import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/profile.dart';
import '../../data/providers/api_provider.dart';
import '../../data/services/user_service.dart';

class ProfileController extends GetxController
    with GetTickerProviderStateMixin, StateMixin {
  final UserService userService = Get.find();

  late String userName;
  late ProfileModel profile;
  late int followingNum;
  late int followersNum;

  late TabController _tabController;

  final ScrollController scrollController = ScrollController();

  final RxBool _detailExpanded = false.obs;

  final RxDouble _hideAppbarFactor = 1.0.obs;
  final RxInt _currentTabIndex = 0.obs;

  int get currentTabIndex => _currentTabIndex.value;

  TabController get tabController => _tabController;

  bool get detailExpanded => _detailExpanded.value;

  double get hideAppbarFactor => _hideAppbarFactor.value;

  set detailExpanded(bool value) {
    _detailExpanded.value = value;
  }

  @override
  void onInit() {
    super.onInit();

    userName = Get.arguments;

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      _currentTabIndex.value = _tabController.index;
    });

    scrollController.addListener(_onScroll);

    loadData();
  }

  void _onScroll() {
    double position = scrollController.position.pixels;
    double hideAppbarHit = scrollController.position.maxScrollExtent;
    double newValue = (hideAppbarHit - position) > 0
        ? (hideAppbarHit - position) / hideAppbarHit
        : 0;
    if (hideAppbarFactor - newValue >= 0.25 ||
        hideAppbarFactor - newValue <= -0.25 ||
        newValue == 0 ||
        newValue == 1) {
      _hideAppbarFactor.value = newValue;
    }
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());

    ProfileModel? profileModel;
    String? message;
    bool success = true;

    await ApiProvider.getProfile(userName).then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        profileModel = value.data;
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    }

    await ApiProvider.getUsersCount(
            path: "/user/${profileModel!.user!.id}/following")
        .then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        followingNum = value.data!;
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    }

    await ApiProvider.getUsersCount(
            path: "/user/${profileModel!.user!.id}/followers")
        .then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        followersNum = value.data!;
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    } else {
      profile = profileModel!;
      change(null, status: RxStatus.success());
    }
  }
}
