import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/users_sort_setting.dart';
import '../../../data/models/user.dart';
import '../../../data/providers/api_provider.dart';

class UsersPreviewListRepository {
  UsersPreviewListRepository();

  Future<GroupResult<UserModel>> getUsers({
    required int currentPage,
    required UsersSortSetting sortSetting,
    required UsersSourceType sourceType,
  }) async {
    String path = "";
    Map<String, dynamic> queryParameters = {"page": currentPage};

    switch (sourceType) {
      case UsersSourceType.followers:
        path = "/user/${sortSetting.userId}/followers";
        break;
      case UsersSourceType.following:
        path = "/user/${sortSetting.userId}/following";
        break;
      case UsersSourceType.search:
        path = "/search";
        queryParameters.addAll({"type": "user", "query": sortSetting.keyword});
        break;
      default:
        break;
    }

    return ApiProvider.getUsers(
      path: path,
      queryParameters: queryParameters,
      type: sourceType,
    ).then((value) {
      List<UserModel> users = [];
      int count = 0;

      if (value.success) {
        users = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: users, count: count);
    });
  }
}
