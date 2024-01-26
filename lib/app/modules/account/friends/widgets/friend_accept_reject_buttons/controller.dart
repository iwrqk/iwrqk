import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../data/models/user.dart';
import '../../../../../data/services/user_service.dart';

class FriendAcceptRejectButtonsController extends GetxController {
  final UserService userService = Get.find();
  late String userId;
  VoidCallback? onChanged;

  final RxBool _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  void init(UserModel user, VoidCallback? callback) {
    userId = user.id;
    onChanged = callback;
  }

  void accpect() {
    _isProcessing.value = true;

    userService.acceptFriendRequest(userId).then((value) {
      _isProcessing.value = false;
      if (value) {
        onChanged?.call();
      }
    });
  }

  void reject() {
    _isProcessing.value = true;

    userService.rejectFriendRequest(userId).then((value) {
      _isProcessing.value = false;
      if (value) {
        onChanged?.call();
      }
    });
  }
}
