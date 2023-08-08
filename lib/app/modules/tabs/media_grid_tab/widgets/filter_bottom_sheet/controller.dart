import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../data/enums/types.dart';
import '../../../../../data/models/account/settings/filter_setting.dart';
import '../../../../../data/services/config_service.dart';
import '../../../../../global_widgets/media_preview/media_preview_grid/controller.dart';
import 'repository.dart';

class FilterBottomSheetController extends GetxController {
  final ConfigService _configService = Get.find();

  final RxInt _selectedYear = 0.obs;
  final RxInt _selectedMonth = 0.obs;
  final Rx<RatingType> _selectedRatingType = RatingType.all.obs;

  final FilterBottomSheetRepository repository = FilterBottomSheetRepository();

  final TextEditingController tagEditingController = TextEditingController();
  final GlobalKey tagEditingControllerKey = GlobalKey();
  final FocusNode tagFocusNode = FocusNode();

  final RxList<String> _selectedTags = <String>[].obs;
  List<String> get selectedTags => _selectedTags.toList();

  late MediaPreviewGridController _targetController;

  late String _targetTag;

  int get selectedYear => _selectedYear.value;

  set selectedYear(int year) {
    _selectedYear.value = year;
  }

  int get selectedMonth => _selectedMonth.value;

  set selectedMonth(int month) {
    _selectedMonth.value = month;
  }

  RatingType get selectedRatingType => _selectedRatingType.value;

  set selectedRatingType(RatingType ratingType) {
    _selectedRatingType.value = ratingType;
  }

  void init(String tabTag) {
    _targetTag = tabTag;
    _targetController = Get.find(tag: _targetTag);
    FilterSettingModel filterSetting = _configService.filterSetting;
    if (!filterSetting.isEmpty()) {
      _selectedYear.value = filterSetting.year ?? 0;
      _selectedMonth.value = filterSetting.month ?? 0;
      _selectedRatingType.value = filterSetting.ratingType ?? RatingType.all;
      _selectedTags.value = filterSetting.tags ?? [];
    }
  }

  void applyFilter() {
    if (_selectedRatingType.value.value == "" &&
        _selectedYear.value == 0 &&
        _selectedMonth.value == 0) {
      return;
    }
    FilterSettingModel filterSetting = FilterSettingModel(
      year: _selectedYear.value == 0 ? null : _selectedYear.value,
      month: _selectedMonth.value == 0 ? null : _selectedMonth.value,
      ratingType: _selectedRatingType.value.value == ""
          ? null
          : _selectedRatingType.value,
      tags: _selectedTags.isEmpty ? null : _selectedTags.toList(),
    );

    if (_configService.filterSetting == filterSetting) {
      return;
    } else {
      _configService.filterSetting = filterSetting;
    }

    _targetController.refreshData(showSplash: true, showFooter: false);
  }

  Future<List<String>> autoCompleteTags(String keyword) async {
    try {
      return await repository.autoCompleteTags(keyword).then((value) {
        return value.map((e) => e.id).toList();
      });
    } catch (e) {
      return [];
    }
  }

  void addTag(String tag) {
    if (_selectedTags.contains(tag)) {
      return;
    }
    _selectedTags.add(tag);
    tagEditingController.clear();
    tagFocusNode.previousFocus();
  }

  void removeTag(String tag) {
    _selectedTags.remove(tag);
  }
}
