import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../data/models/offline/download_task_media.dart';
import '../../../../data/models/offline/offline_media.dart';
import '../../../../data/models/resolution.dart';
import '../../../../data/providers/api_provider.dart';
import '../../../../data/providers/storage_provider.dart';
import '../../../../data/services/download_service.dart';

class CreateVideoDownloadDialogController extends GetxController {
  final DownloadService _downloadService = Get.find();
  late List<ResolutionModel> _resolutions;
  late OfflineMediaModel _previewData;

  final RxInt _currentResolutionIndex = 0.obs;

  int get currentResolutionIndex => _currentResolutionIndex.value;

  set currentResolutionIndex(int value) {
    _currentResolutionIndex.value = value;
  }

  final RxBool _creatingDownloadTask = false.obs;

  bool get creatingDownloadTask => _creatingDownloadTask.value;

  void init(List<ResolutionModel> resolutions, OfflineMediaModel previewData) {
    _resolutions = resolutions;
    _previewData = previewData;
  }

  Future<void> createVideoDownloadTask() async {
    bool success = false;
    late int size;

    _creatingDownloadTask.value = true;

    if (StorageProvider.downloadVideoRecords.containsWhere((element) =>
        element.offlineMedia.id == _previewData.id &&
        _resolutions[currentResolutionIndex].name == element.resolutionName)) {
      SmartDialog.showToast(t.message.download.task_already_exists);
      _creatingDownloadTask.value = false;
      return;
    }

    String downloadUrl = _resolutions[currentResolutionIndex].src.downloadUrl;

    await ApiProvider.getFileSize(downloadUrl).then((value) {
      success = value.success;
      if (value.success) {
        size = value.data!;
      } else {
        SmartDialog.showToast(value.message!);
      }
    });

    if (!success) {
      _creatingDownloadTask.value = false;
      return;
    }

    await _downloadService.currentDownloadingCount.then((value) {
      success = value < _downloadService.maxDownloadingCount;
      if (!success) {
        SmartDialog.showToast(
            t.message.download.maximum_simultaneous_download_reached);
      }
    });

    await _downloadService
        .addVideoDownloadTask(
      url: downloadUrl,
      offlineMedia:
          DownloadTaskMediaModel.fromOfflineMediaModel(_previewData, size),
      resolutionName: _resolutions[currentResolutionIndex].name,
    )
        .then((value) {
      success &= value;
    });

    _creatingDownloadTask.value = false;

    if (success) {
      Get.back();
      SmartDialog.showToast(t.message.download.task_created);
    }
  }
}
