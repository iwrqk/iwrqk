import '../../../../../data/enums/result.dart';
import '../../../../../data/models/forum/post.dart';
import '../../../../../data/providers/network/api_provider.dart';

class PostListRepository {
  PostListRepository();

  Future<GroupResult<PostModel>> getThreadPosts({
    required String channelName,
    required String threadId,
    required int currentPage,
  }) async {
    return await ApiProvider.getThreadPosts(
            channelName: channelName, threadId: threadId, pageNum: currentPage)
        .then((value) {
      List<PostModel> posts = [];
      int count = 0;

      if (value.success) {
        posts = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(
        count: count,
        results: posts,
      );
    });
  }
}
