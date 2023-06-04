import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../data/models/user.dart';
import '../../sliver_refresh/controller.dart';
import 'repository.dart';

class UsersPreviewListController extends SliverRefreshController<UserModel> {
  final UsersPreviewListRepository repository = UsersPreviewListRepository();

  late UsersSortSetting _sortSetting;
  late UsersSourceType _sourceType;

  bool initializated = false;

  void initConfig(UsersSortSetting sortSetting, UsersSourceType sourceType) {
    _sortSetting = sortSetting;
    _sourceType = sourceType;

    initializated = true;
  }

  Future<void> resetKeyword(String keyword) async {
    if (!initializated) return;

    _sortSetting.keyword = keyword;
    await refreshData(showSplash: true, showFooter: false)
        .then((value) => null);
  }

  @override
  Future<GroupResult<UserModel>> getNewData(int currentPage) {
    return repository.getUsers(
      currentPage: currentPage,
      sortSetting: _sortSetting,
      sourceType: _sourceType,
    );
  }
}
