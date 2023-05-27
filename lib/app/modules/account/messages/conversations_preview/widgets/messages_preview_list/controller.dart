import 'package:iwrqk/app/data/enums/result.dart';
import 'package:iwrqk/app/data/models/conversations/conversation.dart';

import '../../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class ConversationsPreviewListController
    extends SliverRefreshController<ConversationModel> {
  final ConversationsPreviewListRepository repository =
      ConversationsPreviewListRepository();

  late String _userId;

  void initConfig(String userId) {
    _userId = userId;
  }

  @override
  Future<GroupResult<ConversationModel>> getNewData(int currentPage) {
    return repository.getConversations(userId: _userId, currentPage: currentPage);
  }
}
