import 'package:iwrqk/app/data/enums/result.dart';

import '../../../../../data/models/forum/thread.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class ThreadPreviewListController extends SliverRefreshController<ThreadModel> {
  final ThreadPreviewListRepository repository = ThreadPreviewListRepository();

  late String _channelName;

  void initConfig(String channelName) {
    _channelName = channelName;
  }

  @override
  Future<GroupResult<ThreadModel>> getNewData(int currentPage) {
    return repository.getChannelThreads(
        channelName: _channelName, pageNum: currentPage);
  }
}
