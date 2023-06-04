import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../data/enums/state.dart';
import '../../../../data/models/account/conversations/message.dart';
import '../../../../data/providers/api_provider.dart';

class ConversationDetailController extends GetxController with StateMixin {
  ConversationDetailController();

  late String conversationId;
  late String userId;

  final RxList<MessageModel> _messages = <MessageModel>[].obs;
  List<MessageModel> get messages => _messages;
  set messages(List<MessageModel> value) => _messages.value = value;

  DateTime _currentFirstMessageDate = DateTime.now();

  bool _noMore = false;

  @override
  void onInit() {
    super.onInit();

    conversationId = Get.arguments['conversationId']!;
    userId = Get.arguments['userId']!;

    loadData();
  }

  void reachTop() {
    if (messages.isNotEmpty && !_noMore) {
      loadData();
    }
  }

  Future<void> loadData() async {
    change(IwrState.loading, status: RxStatus.success());
    try {
      await ApiProvider.getMessages(
        conversationId,
        _currentFirstMessageDate.toIso8601String(),
      ).then((value) {
        int count = 0;

        if (value.success) {
          messages.addAll(value.data!.results);
          _currentFirstMessageDate = DateTime.parse(value.data!.first);
          count = value.data!.count;

          if (messages.length < count) {
            change(IwrState.success, status: RxStatus.success());
          } else {
            _noMore = true;
            change(IwrState.noMore, status: RxStatus.success());
          }
        } else {
          showToast(value.message!);
          change(IwrState.fail, status: RxStatus.success());
        }
      });
    } catch (e) {
      showToast(e.toString());
      change(IwrState.fail, status: RxStatus.success());
    }
  }
}
