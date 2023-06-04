import '../../../../../data/enums/result.dart';
import '../../../../../data/models/account/friend_request.dart';
import '../../../../../data/providers/api_provider.dart';

class FriendRequestsListRepository {
  FriendRequestsListRepository();

  Future<GroupResult<FriendRequestModel>> getFriendRequests({
    required String userId,
    required int currentPage,
  }) {
    return ApiProvider.getFriendRequests(
      userId: userId,
      pageNum: currentPage,
    ).then((value) {
      List<FriendRequestModel> friends = [];
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
