import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';
import '../../../data/services/user_service.dart';

class FriendButtonController extends GetxController {
  late String _userId;
  final UserService userService = Get.find();
  final Rx<FriendRelationType> _relation = FriendRelationType.unknown.obs;

  FriendRelationType get relation => _relation.value;

  final RxBool _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  @override
  void onInit() {
    _isProcessing.value = true;
    super.onInit();
  }

  void init(UserModel user) {
    _userId = user.id;
    getFriendRelation().then((value) => _isProcessing.value = false);
  }

  Future<bool> getFriendRelation() async {
    bool success = false;
    if (!userService.accountService.isLogin) {
      _isProcessing.value = false;
      return success;
    }

    await userService.getFriendRelation(_userId).then((value) {
      if (value.success) {
        _relation.value = value.data!;
        success = true;
      }
    });

    return success;
  }

  Future<void> sendFriendRequest(BuildContext context) async {
    bool success = true;
    _isProcessing.value = true;

    if (_relation.value == FriendRelationType.unknown) {
      await getFriendRelation().then((value) {
        success = value;
      });
    }

    if (!success) {
      _isProcessing.value = false;
      return;
    }

    await userService.sendFriendRequest(_userId).then((value) {
      if (value) {
        _relation.value = FriendRelationType.pending;
      }
    });

    _isProcessing.value = false;
  }

  Future<void> unfriend(BuildContext context) async {
    _isProcessing.value = true;

    await userService.unfriend(_userId).then((value) {
      if (value) {
        _relation.value = FriendRelationType.none;
      }
    });

    _isProcessing.value = false;
  }
}
