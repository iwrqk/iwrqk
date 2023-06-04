import '../../../../../../data/enums/result.dart';
import '../../../../../../data/models/account/conversations/conversation.dart';
import '../../../../../../data/providers/api_provider.dart';

class ConversationsPreviewListRepository {
  ConversationsPreviewListRepository();

  Future<GroupResult<ConversationModel>> getConversations({
    required String userId,
    required currentPage,
  }) {
    return ApiProvider.getConversations(userId, currentPage).then((value) {
      List<ConversationModel> conversations = [];
      int count = 0;

      if (value.success) {
        conversations = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: conversations, count: count);
    });
  }
}
