import 'package:get/get.dart';

import '../../../data/services/user_service.dart';
import 'widgets/friend_requests_list/controller.dart';
import 'widgets/friends_preview_list/controller.dart';

class FriendsController extends GetxController {
  late FriendsPreviewListController friendsPreviewListController;
  late FriendRequestsListController friendRequestsListController;

  final String friendsPreviewListTag = "friends_preview_list";
  final String friendRequestsListTag = "friend_requests_list";

  final UserService userService = Get.find();

  @override
  void onInit() {
    super.onInit();

    Get.lazyPut(() => FriendsPreviewListController(),
        tag: friendsPreviewListTag);
    Get.lazyPut(() => FriendRequestsListController(),
        tag: friendRequestsListTag);
  }
}
