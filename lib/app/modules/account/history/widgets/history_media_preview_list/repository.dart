import 'dart:math';

import '../../../../../core/const/widget.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/offline/history_media.dart';
import '../../../../../data/providers/storage_provider.dart';

class HistoryMediaPreviewListRepository {
  HistoryMediaPreviewListRepository();

  GroupResult<HistoryMediaModel> getHistoryMedias(int currentPage) {
    List<HistoryMediaModel> histories = StorageProvider.historyList;

    var newData = histories.getRange(currentPage * WidgetConst.pageLimit,
        min((currentPage + 1) * WidgetConst.pageLimit, histories.length));

    return GroupResult(
      results: newData.toList(),
      count: histories.length,
    );
  }
}
