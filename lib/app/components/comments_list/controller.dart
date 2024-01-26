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
