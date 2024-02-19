import 'package:get/get.dart';

import '../../data/models/rule.dart';
import '../../data/providers/api_provider.dart';
import '../../data/providers/storage_provider.dart';
import '../../routes/pages.dart';

class RulesController extends GetxController with StateMixin {
  List<RuleModel> rules = [];
  final RxString _language = 'en'.obs;
  String get language => _language.value;
  set language(String value) => _language.value = value;

  List<String> get languages => rules[0].title.keys.toList();

  @override
  void onInit() {
    super.onInit();
    loadData();
    change(null, status: RxStatus.loading());
  }

  Future<void> refreshData({bool showSplash = false}) async {
    rules.clear();
    if (showSplash) {
      change(null, status: RxStatus.loading());
    } else {
      change(null, status: RxStatus.success());
    }
    await loadData();
  }

  Future<void> loadData() async {
    String? message;
    bool success = true;

    await ApiProvider.getRules().then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        for (var item in value.data!) {
          rules.add(item);
        }
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    } else {
      if (Get.deviceLocale != null) {
        if (languages.contains(Get.deviceLocale!.languageCode)) {
          _language.value = Get.deviceLocale!.languageCode;
        } else {
          _language.value = 'en';
        }
      }
      change(null, status: RxStatus.success());
    }
  }

  void acceptRules() {
    StorageProvider.config[StorageKey.accpetedRules] = true;
    Get.offNamedUntil(AppRoutes.splash, (route) => false);
  }
}
