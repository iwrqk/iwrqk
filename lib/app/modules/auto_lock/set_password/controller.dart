import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/services/auto_lock_service.dart';

class SetPasswordController extends GetxController
    with GetTickerProviderStateMixin {
  final AutoLockService _autoLockService = Get.find();
  final RxString _currentPassword = ''.obs;
  late String _savedPassword;
  final RxBool _confirmingPassword = false.obs;

  bool get confirmingPassword => _confirmingPassword.value;

  final FocusNode keyboardNode = FocusNode();
  late AnimationController passwordErrorShakeController;
  late Animation<double> passwordErrorShakeAnimation;

  String get currentPassword => _currentPassword.value;

  void addPassword(String password) {
    if (_currentPassword.value.length >= 6) return;
    _currentPassword.value += password;
    if (_currentPassword.value.length == 6) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        if (confirmingPassword) {
          _checkPassword();
        } else {
          _savedPassword = _currentPassword.value;
          _confirmingPassword.value = true;
          _currentPassword.value = '';
        }
      });
    }
  }

  void removePassword() {
    if (_currentPassword.value.isEmpty) return;
    _currentPassword.value =
        _currentPassword.value.substring(0, _currentPassword.value.length - 1);
  }

  @override
  void onInit() {
    super.onInit();
    passwordErrorShakeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    passwordErrorShakeAnimation = Tween<double>(begin: 0, end: 1)
        .chain(
          CurveTween(curve: Curves.easeOutExpo),
        )
        .animate(passwordErrorShakeController);
    HardwareKeyboard.instance.addHandler(handleKeyboardEvent);
  }

  @override
  void onClose() {
    super.onClose();
    HardwareKeyboard.instance.removeHandler(handleKeyboardEvent);
  }

  void _checkPassword() {
    if (_currentPassword.value == _savedPassword) {
      _autoLockService.password = _currentPassword.value;
      Get.back(result: true);
    } else {
      passwordErrorShakeController.forward(from: 0);
      _currentPassword.value = '';
    }
  }

  bool handleKeyboardEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      String keyLabel = event.logicalKey.keyLabel;
      if (keyLabel.isNum) {
        if (int.parse(keyLabel) < 0 || int.parse(keyLabel) > 9) return false;
        addPassword(event.logicalKey.keyLabel);
        return true;
      } else if (event.logicalKey.keyLabel == "Backspace") {
        removePassword();
        return true;
      }
    }
    return false;
  }
}
