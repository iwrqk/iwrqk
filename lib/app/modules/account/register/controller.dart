import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../core/const/widget.dart';
import '../../../core/utils/display_util.dart';
import '../../../data/providers/network/api_provider.dart';
import '../../../global_widgets/dialogs/loading_dialog/widget.dart';

class RegisterController extends GetxController with StateMixin {
  final RegExp emailRegExp = RegExp(WidgetConst.emailRegExp);
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? captcha;

  late String _captchaId;

  final Rx<Uint8List> _imageData = Rx<Uint8List>(Uint8List(0));

  Uint8List get imageData => _imageData.value;

  GlobalKey<FormState> get formKey => _formKey;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    try {
      await ApiProvider.networkProvider.get("/captcha").then((value) {
        _imageData.value = base64Decode(value.data["data"].split(',').last);
        _captchaId = value.data["id"];
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void register() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    Get.dialog(
      LoadingDialog(
        task: () async {
          await ApiProvider.register(_captchaId, email!, captcha!)
              .then((value) {
            if (!value.success) {
              throw DisplayUtil.getErrorMessage(value.message!);
            }
          });
        },
        onFail: () {
          loadData();
        },
        successMessage: L10n.of(Get.context!).message_register_success,
        onSuccess: () {
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }
}
