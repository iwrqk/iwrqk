import 'dart:math';

import 'package:iwrqk/app/const/widget.dart';

import '../../../../../data/enums/result.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../data/providers/storage_provider.dart';

class DownloadMediaPreviewListRepository {
  DownloadMediaPreviewListRepository();

  GroupResult<MediaDownloadTask> getDownloadRecords(int currentPage) {
    List<MediaDownloadTask> records = [];

    records = StorageProvider.downloadVideoRecords.get();

    var newData = records.getRange(currentPage * WidgetConst.pageLimit,
        min((currentPage + 1) * WidgetConst.pageLimit, records.length));

    return GroupResult(
      results: newData.toList(),
      count: records.length,
    );
  }
}
