import 'dart:math';

import '../../../../../core/const/widget.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../data/providers/storage_provider.dart';

class DownloadMediaPreviewListRepository {
  DownloadMediaPreviewListRepository();

  GroupResult<MediaDownloadTask> getDownloadRecords(
      int currentPage, MediaType type) {
    List<MediaDownloadTask> records = [];

    if (type == MediaType.video) {
      records = StorageProvider.downloadVideoRecords;
    }

    var newData = records.getRange(currentPage * WidgetConst.pageLimit,
        min((currentPage + 1) * WidgetConst.pageLimit, records.length));

    return GroupResult(
      results: newData.toList(),
      count: records.length,
    );
  }
}
