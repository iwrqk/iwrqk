import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/offline/history_media.dart';
import '../../controller.dart';
import 'repository.dart';

class HistoryMediaPreviewListController
    extends IwrRefreshController<HistoryMediaModel> {
  final HistoryMediaPreviewListRepository repository =
      HistoryMediaPreviewListRepository();

  late HistoryController _parentController;

  void initConfig(HistoryController parentController) {
    _parentController = parentController;
  }

  void toggleCheckedAll() {
    for (var item in data) {
      _parentController.toggleChecked(item.id, true);
    }
    update();
  }

  @override
  Future<GroupResult<HistoryMediaModel>> getNewData(int currentPage) async =>
      repository.getHistoryMedias(currentPage);
}
