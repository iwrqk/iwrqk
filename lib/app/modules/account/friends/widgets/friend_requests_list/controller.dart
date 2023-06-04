import '../../../../../data/enums/result.dart';
import '../../../../../data/models/account/friend_request.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class FriendRequestsListController
    extends SliverRefreshController<FriendRequestModel> {
  final FriendRequestsListRepository repository =
      FriendRequestsListRepository();

  late String _userId;

  void initConfig(String userId) {
    _userId = userId;
  }

  @override
  Future<GroupResult<FriendRequestModel>> getNewData(int currentPage) {
    return repository.getFriendRequests(
      userId: _userId,
      currentPage: currentPage,
    );
  }
}
