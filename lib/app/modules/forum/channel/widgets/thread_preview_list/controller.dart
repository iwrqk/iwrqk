import 'package:iwrqk/app/data/enums/result.dart';

import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/models/forum/thread.dart';

import 'repository.dart';

class ThreadPreviewListController extends IwrRefreshController<ThreadModel> {
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
