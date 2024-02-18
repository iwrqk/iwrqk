import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/forum/post.dart';
import '../../../../../data/services/user_service.dart';
import 'repository.dart';

class PostListController extends IwrRefreshController<PostModel> {
  final UserService userService = Get.find();

  final PostListRepository repository = PostListRepository();
  PostListController();

  late String _channelName;
  late String _threadId;

  void initConfig(String channelName, String threadId) {
    _channelName = channelName;
    _threadId = threadId;
  }

  void updateAfterSend() {
    if (totalPage == currentPage + 1 || totalPage == 0) {
      refreshData(showSplash: true);
    }
  }

  void updateContent(int index, String content) {
    if (data.isNotEmpty) {
      data[index].body = content;
      data[index].updateAt = DateTime.now().toIso8601String();
      update();
    }
  }

  void deleteComment(int index) {
    if (data.isNotEmpty) {
      data.removeAt(index);
      update();
    }
  }

  @override
  Future<GroupResult<PostModel>> getNewData(int currentPage) {
    return repository.getThreadPosts(
      channelName: _channelName,
      threadId: _threadId,
      currentPage: currentPage,
    );
  }
}
