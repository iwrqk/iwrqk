import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/comment.dart';
import '../../sliver_refresh/controller.dart';
import 'repository.dart';

class CommentsListController extends SliverRefreshController<CommentModel> {
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
