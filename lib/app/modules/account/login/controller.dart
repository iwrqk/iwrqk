import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../core/utils/display_util.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/services/account_service.dart';
import '../../../global_widgets/dialogs/loading_dialog/widget.dart';
import '../../../routes/pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? account;
  String? password;

  final RxBool _passwordVisibility = false.obs;

  bool get passwordVisibility => _passwordVisibility.value;

  final AccountService _accountService = Get.find();

  @override
  void onInit() {
    super.onInit();
    StorageProvider.savedUserAccountPassword.then((value) {
      if (value != null) {
        accountController.text = value["account"];
        passwordController.text = value["password"];
      }
    });
  }

  void togglePasswordVisibility() {
    _passwordVisibility.value = !_passwordVisibility.value;
  }

  void login(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    Get.dialog(
      LoadingDialog(
        task: () async {
          await _accountService
              .login(account: account!, password: password!)
              .then((value) {
            if (!value.success) {
              throw DisplayUtil.getErrorMessage(value.message!);
            }
          });
        },
        onSuccess: () {
          Get.offNamedUntil(AppRoutes.root, (route) => false);
          StorageProvider.setSavedUserAccountPassword(account!, password!);
        },
        successMessage: L10n.of(context).message_login_success,
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    super.onClose();
    if (!_accountService.isLogin) {
      cancel();
    }
  }

  void cancel() {
    _accountService.logout();
  }
}
