import '../../../../../data/enums/result.dart';
import '../../../../../data/models/user.dart';
import '../../../../../data/providers/api_provider.dart';

class FriendsPreviewListRepository {
  FriendsPreviewListRepository();

  Future<GroupResult<UserModel>> getFriends({
    required String userId,
    required int currentPage,
  }) {
    return ApiProvider.getFriends(
      userId: userId,
      pageNum: currentPage,
    ).then((value) {
      List<UserModel> friends = [];
      int count = 0;

      if (value.success) {
        friends = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: friends, count: count);
    });
  }
}
