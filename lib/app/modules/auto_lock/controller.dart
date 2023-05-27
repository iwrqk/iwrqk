import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import '../../core/utils/display_util.dart';
import '../../data/services/auto_lock_service.dart';

class LockController extends GetxController with GetTickerProviderStateMixin {
  final AutoLockService autoLockService = Get.find();

  final RxString _currentPassword = ''.obs;

  late List<BiometricType> _availableBiometrics;
  late bool _canCheckBiometrics;
  final FocusNode keyboardNode = FocusNode();
  late AnimationController passwordErrorShakeController;
  late Animation<double> passwordErrorShakeAnimation;

  final LocalAuthentication auth = LocalAuthentication();

  final IOSAuthMessages iOSAuthMessages = IOSAuthMessages(
    cancelButton: DisplayUtil.cancel,
  );

  AndroidAuthMessages androidAuthMessages = AndroidAuthMessages(
    signInTitle: DisplayUtil.authenticateRequired,
    biometricHint: DisplayUtil.messageAuthenticateToContinue,
    cancelButton: DisplayUtil.cancel,
  );

  String get currentPassword => _currentPassword.value;

  void addPassword(String password) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (_currentPassword.value.length >= 6) return;
      _currentPassword.value += password;
      if (_currentPassword.value.length == 6) {
        _checkPassword();
      }
    });
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
    if (autoLockService.enableAuthByBiometrics) {
      auth.canCheckBiometrics.then((value) => _canCheckBiometrics = value);
      auth
          .getAvailableBiometrics()
          .then((value) => _availableBiometrics = value);
    }
    if (autoLockService.password.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((Duration callback) {
        Get.back();
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    HardwareKeyboard.instance.removeHandler(handleKeyboardEvent);
  }

  void _checkPassword() {
    if (_currentPassword.value == autoLockService.password) {
      Get.back();
    } else {
      passwordErrorShakeController.forward(from: 0);
      _currentPassword.value = '';
    }
  }

  void authByBiometrics() async {
    if (!_canCheckBiometrics || _availableBiometrics.isEmpty) return;

    bool didAuthenticate = await auth.authenticate(
      localizedReason: DisplayUtil.messageAuthenticateToContinue,
      authMessages: <AuthMessages>[
        androidAuthMessages,
        iOSAuthMessages,
      ],
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (didAuthenticate) {
      Get.back();
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
