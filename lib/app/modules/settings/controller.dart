import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/services/account_service.dart';
import '../../data/services/auto_lock_service.dart';
import '../../data/services/config_service.dart';
import '../../routes/pages.dart';

class SettingsController extends GetxController {
  final ConfigService configService = Get.find();
  final AccountService accountService = Get.find();
  final AutoLockService autoLockService = Get.find();

  late List<BiometricType> _availableBiometrics;
  late bool _canCheckBiometrics;

  final LocalAuthentication auth = LocalAuthentication();

  IOSAuthMessages iOSAuthMessages = IOSAuthMessages(
    cancelButton: DisplayUtil.cancel,
  );

  AndroidAuthMessages androidAuthMessages = AndroidAuthMessages(
    signInTitle: DisplayUtil.authenticateRequired,
    biometricHint: DisplayUtil.messageAuthenticateToEnableBiometric,
    cancelButton: DisplayUtil.cancel,
  );

  @override
  void onInit() {
    super.onInit();
    auth.canCheckBiometrics.then((value) => _canCheckBiometrics = value);
    auth.getAvailableBiometrics().then((value) => _availableBiometrics = value);
  }

  Future<bool> getBiometricsAuth() async {
    if (!_canCheckBiometrics || _availableBiometrics.isEmpty) return false;

    bool didAuthenticate = await auth.authenticate(
      localizedReason: DisplayUtil.messageAuthenticateToEnableBiometric,
      authMessages: <AuthMessages>[
        androidAuthMessages,
        iOSAuthMessages,
      ],
      options: const AuthenticationOptions(biometricOnly: true),
    );

    return didAuthenticate;
  }

  String getCurrentThemeName(BuildContext context) {
    return configService.themeMode == ThemeMode.system
        ? L10n.of(context).theme_system
        : configService.themeMode == ThemeMode.light
            ? L10n.of(context).theme_light_mode
            : L10n.of(context).theme_dark_mode;
  }

  String getCurrentLanguageName() {
    return L10n.languageMap[configService.localeCode]!;
  }

  void logout() {
    accountService.logout();
    Get.offNamedUntil(AppRoutes.root, (route) => false);
  }

  void checkUpdate() {
    configService.checkLatestVersion();
  }
}
