import 'package:get/get.dart';

import '../../data/enums/result.dart';
import '../../data/enums/types.dart';
import '../../data/models/comment.dart';
import '../../data/services/user_service.dart';
import '../iwr_refresh/controller.dart';
import 'repository.dart';

class CommentsListController extends IwrRefreshController<CommentModel> {
  final UserService userService = Get.find();

  final CommentsListRepository repository = CommentsListRepository();

  late String _sourceId;
  String? _parentId;
  late CommentsSourceType _sourceType;

  void initConfig(String id, CommentsSourceType sourceType, String? parentId) {
    _sourceId = id;
    _sourceType = sourceType;
    _parentId = parentId;
  }

  void updateAfterSend() {
    if (totalPage == currentPage + 1 || totalPage == 0) {
      refreshData(showSplash: true);
    }
  }

  void updateContent(int index, String content) {
    if (data.isNotEmpty) {
      data[index].body = content;
      data[index].updatedAt = DateTime.now().toIso8601String();
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
  Future<GroupResult<CommentModel>> getNewData(int currentPage) {
    return repository.getComments(
      currentPage: currentPage,
      sourceId: _sourceId,
      sourceType: _sourceType,
      parentId: _parentId,
    );
  }
}
