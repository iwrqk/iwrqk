import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/intl_localizations.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/utils/log_util.dart';
import 'app/data/providers/storage_provider.dart';
import 'app/data/services/auto_lock_service.dart';
import 'app/data/services/config_service.dart';
import 'app/modules/splash/binding.dart';
import 'app/routes/pages.dart';
import 'getx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageProvider.init();
  await LogUtil.init();
  await FlutterDownloader.initialize(debug: kDebugMode);

  initGetx();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ConfigService _configService = Get.find();
  final AutoLockService _autoLockService = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _configService.calculateGridChildAspectRatio(
        MediaQuery.of(Get.context!).size,
        MediaQuery.of(Get.context!).orientation,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _autoLockService.resumed();
        break;
      // case AppLifecycleState.detached:
      //   DownloadService downloadService = Get.find();
      //   downloadService.pauseAllTasks();
      default:
    }
  }

  Widget _buildSystemUI(BuildContext context, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      child: child ?? Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget myApp() {
      return Obx(
        () => GetMaterialApp(
          locale: _configService.localeCode.isNotEmpty &&
                  _configService.languageSetted
              ? _configService.locale
              : null,
          builder: _buildSystemUI,
          localeListResolutionCallback:
              _configService.localeListResolutionCallback,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppRoutes.root,
          initialBinding: SplashBinding(),
          defaultTransition: Transition.native,
          getPages: AppPages.pages,
          navigatorObservers: [AppPages.routeObserver],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _configService.themeMode,
        ),
      );
    }

    return OKToast(
      position: ToastPosition.bottom,
      child: myApp(),
    );
  }
}
