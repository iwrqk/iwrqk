import '../../../../../data/enums/result.dart';
import '../../../../../data/models/forum/thread.dart';
import '../../../../../data/providers/network/api_provider.dart';

class ThreadPreviewListRepository {
  ThreadPreviewListRepository();

  Future<GroupResult<ThreadModel>> getChannelThreads({
    required String channelName,
    required int pageNum,
  }) async {
    return await ApiProvider.getChannelThreads(
            channelName: channelName, pageNum: pageNum)
        .then((value) {
      List<ThreadModel> threads = [];
      int count = 0;

      if (value.success) {
        threads = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: threads, count: count);
    });
  }
}
