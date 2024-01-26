import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/forum/post.dart';
import 'repository.dart';

class PostListController extends IwrRefreshController<PostModel> {
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
