import 'package:get/get.dart';

import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/media/media.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import '../../../data/services/config_service.dart';
import '../../sliver_refresh/controller.dart';
import 'repository.dart';

class MediaPreviewGridController extends SliverRefreshController<MediaModel> {
  final MediaPreviewGridRepository repository = MediaPreviewGridRepository();
  final ConfigService configService = Get.find();

  late MediaSortSettingModel _sortSetting;
  late MediaSourceType _sourceType;

  void initConfig(
      MediaSortSettingModel sortSetting, MediaSourceType sourceType) {
    _sortSetting = sortSetting;
    _sourceType = sourceType;
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    return repository.getPreviews(
      currentPage: currentPage,
      sortSetting: _sortSetting,
      sourceType: _sourceType,
      filterSetting: configService.filterSetting,
    );
  }
}
