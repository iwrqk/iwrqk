import '../../../../../data/enums/result.dart';
import '../../../../../data/models/offline/history_meida.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class HistoryMediaPreviewListController
    extends SliverRefreshController<HistoryMediaModel> {
  final HistoryMediaPreviewListRepository repository =
      HistoryMediaPreviewListRepository();

  @override
  Future<GroupResult<HistoryMediaModel>> getNewData(int currentPage) async =>
      repository.getHistoryMedias(currentPage);
}
