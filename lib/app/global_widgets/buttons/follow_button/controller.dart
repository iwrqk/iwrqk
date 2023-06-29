import 'package:get/get.dart';

import '../../../data/models/user.dart';
import '../../../data/services/user_service.dart';

class FollowButtonController extends GetxController {
  final RxBool _isFollowing = false.obs;
  final UserService userService = Get.find();
  late String userId;

  bool get isFollowing => _isFollowing.value;

  final RxBool _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  void init(UserModel user) {
    _isFollowing.value = user.following;
    userId = user.id;
  }

  void followUploader() {
    _isProcessing.value = true;

    userService.followUser(userId).then((value) {
      _isProcessing.value = false;
      if (value) {
        _isFollowing.value = true;
      }
    });
  }

  void unfollowUploader() {
    _isProcessing.value = true;

    userService.unfollowUser(userId).then((value) {
      _isProcessing.value = false;
      if (value) {
        _isFollowing.value = false;
      }
    });
  }
}
