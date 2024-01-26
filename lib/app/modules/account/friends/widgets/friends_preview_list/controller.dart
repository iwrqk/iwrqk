import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/user.dart';

import 'repository.dart';

class FriendsPreviewListController extends IwrRefreshController<UserModel> {
  final FriendsPreviewListRepository repository =
      FriendsPreviewListRepository();

  late String _userId;

  void initConfig(String userId) {
    _userId = userId;
  }

  @override
  Future<GroupResult<UserModel>> getNewData(int currentPage) {
    return repository.getFriends(userId: _userId, currentPage: currentPage);
  }
}
