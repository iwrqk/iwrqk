import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/comment.dart';
import '../../../data/providers/network/api_provider.dart';

class CommentsListRepository {
  CommentsListRepository();

  Future<GroupResult<CommentModel>> getComments({
    required int currentPage,
    required String sourceId,
    required CommentsSourceType sourceType,
    String? parentId,
  }) async {
    late Future<ApiResult<GroupResult<CommentModel>>> task;

    switch (sourceType) {
      case CommentsSourceType.video:
        task = ApiProvider.getComments(
          id: sourceId,
          type: "video",
          pageNum: currentPage,
          isPreview: true,
        );
        break;
      case CommentsSourceType.image:
        task = ApiProvider.getComments(
          id: sourceId,
          type: "image",
          pageNum: currentPage,
          isPreview: true,
        );
        break;
      case CommentsSourceType.profile:
        task = ApiProvider.getComments(
          id: sourceId,
          type: "profile",
          pageNum: currentPage,
          isPreview: true,
        );
        break;
      case CommentsSourceType.videoReplies:
        task = ApiProvider.getReplies(
          parentId: parentId!,
          sourceType: "video",
          sourceId: sourceId,
          pageNum: currentPage,
        );
        break;
      case CommentsSourceType.imageReplies:
        task = ApiProvider.getReplies(
          parentId: parentId!,
          sourceType: "image",
          sourceId: sourceId,
          pageNum: currentPage,
        );
        break;
      case CommentsSourceType.profileReplies:
        task = ApiProvider.getReplies(
          parentId: parentId!,
          sourceType: "profile",
          sourceId: sourceId,
          pageNum: currentPage,
        );
        break;
    }

    return await task.then((value) {
      List<CommentModel> comments = [];
      int count = 0;

      if (value.success) {
        comments = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(
        count: count,
        results: comments,
      );
    });
  }
}
