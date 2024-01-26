import 'package:get/get.dart';

import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/media_search_setting.dart';
import '../../../data/models/media/media.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import '../../../data/services/config_service.dart';
import '../../iwr_refresh/controller.dart';
import 'repository.dart';

class MediaPreviewGridController extends IwrRefreshController<MediaModel> {
  final MediaPreviewGridRepository repository = MediaPreviewGridRepository();
  final ConfigService configService = Get.find();

  MediaSortSettingModel? _sortSetting;
  late MediaSourceType _sourceType;
  MediaSearchSettingModel? _searchSetting;
  late bool _applyFilter;

  void initConfig({
    required MediaSortSettingModel? sortSetting,
    required MediaSourceType sourceType,
    MediaSearchSettingModel? searchSetting,
    required bool applyFilter,
  }) {
    _sortSetting = sortSetting;
    _sourceType = sourceType;
    _searchSetting = searchSetting;
    _applyFilter = applyFilter;
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    if (_searchSetting != null) {
      return repository.getSearchPreviews(
        currentPage: currentPage,
        searchSetting: _searchSetting!,
      );
    }

    return repository.getPreviews(
      currentPage: currentPage,
      sortSetting: _sortSetting!,
      sourceType: _sourceType,
      filterSetting: configService.filterSetting,
      applyFilter: _applyFilter,
    );
  }
}
