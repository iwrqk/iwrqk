
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/forum/post.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class PostListController extends SliverRefreshController<PostModel> {
  final PostListRepository repository = PostListRepository();
  PostListController();

  late String _channelName;
  late String _threadId;

  void initConfig(String channelName, String threadId) {
    _channelName = channelName;
    _threadId = threadId;
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
