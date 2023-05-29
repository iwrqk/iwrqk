import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../data/models/offline/download_task_media.dart';
import '../../../../data/models/offline/offline_meida.dart';
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

  Future<void> createVideoDownloadTask(
    String createdMessage,
  ) async {
    bool success = false;
    late int size;

    _creatingDownloadTask.value = true;

    for (var item in StorageProvider.downloadVideoRecords) {
      if (item.offlineMeida.id == _previewData.id &&
          _resolutions[currentResolutionIndex].name == item.resolutionName) {
        showToast('已存在下载任务');
        _creatingDownloadTask.value = false;
        return;
      }
    }

    String downloadUrl = _resolutions[currentResolutionIndex].src.downloadUrl;

    await ApiProvider.getFileSize(downloadUrl).then((value) {
      success = value.success;
      if (value.success) {
        size = value.data!;
      } else {
        showToast(value.message!);
      }
    });

    if (!success) {
      _creatingDownloadTask.value = false;
      return;
    }

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
      showToast(createdMessage);
    }
  }
}
