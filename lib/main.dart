import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';

import 'app/data/services/plugin/pl_player/service_locator.dart';
import 'app/modules/media_detail/page.dart';
import 'app/utils/proxy_util.dart';
import 'i18n/strings.g.dart';
import 'app/data/providers/storage_provider.dart';
import 'app/data/services/config_service.dart';
import 'app/routes/pages.dart';
import 'app/utils/log_util.dart';
import 'getx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await StorageProvider.init();
  await LogUtil.init();
  await FlutterDownloader.initialize(debug: kDebugMode);
  ProxyUtil.init();
  await setupServiceLocator();

  initGetx();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  // Set language
  bool firstRun;
  firstRun = StorageProvider.config[DynamicConfigKey.firstRun] == null;

  if (!firstRun) {
    LocaleSettings.setLocaleRaw(
        StorageProvider.config.get(ConfigKey.localeCode, defaultValue: "en"));
  } else {
    StorageProvider.config[DynamicConfigKey.firstRun] = false;
    StorageProvider.config[ConfigKey.localeCode] =
        LocaleSettings.useDeviceLocale().languageCode;
  }

  runApp(TranslationProvider(
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final ConfigService _configService = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Set high refresh rate
    if (GetPlatform.isAndroid) {
      try {
        late List modes;
        FlutterDisplayMode.supported.then((value) {
          modes = value;
          var storageDisplay = _configService.config.get(ConfigKey.displayMode);
          DisplayMode f = DisplayMode.auto;
          if (storageDisplay != null) {
            f = modes.firstWhere((e) => e.toString() == storageDisplay);
          }
          DisplayMode preferred = modes.toList().firstWhere((el) => el == f);
          FlutterDisplayMode.setPreferredMode(preferred);
        });
      } catch (_) {}
    }

    // Set grid child aspect ratio
    setGridChildAspectRatio();
  }

  void setGridChildAspectRatio() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _configService.calculateGridChildAspectRatio(
        MediaQuery.of(Get.context!).size,
        MediaQuery.of(Get.context!).orientation,
      );
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setGridChildAspectRatio();
  }

  Widget _buildToast(BuildContext context, Widget? child) {
    return FlutterSmartDialog(
      toastBuilder: (String msg) => Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 32,
          right: 16,
          left: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          msg,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    _configService.resetEasyRefresh();

    Widget mainApp() => DynamicColorBuilder(
          builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme? lightColorScheme;
            ColorScheme? darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();
              darkColorScheme = darkDynamic.harmonized();
            } else {
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.lightBlue,
                brightness: Brightness.light,
              );
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.lightBlue,
                brightness: Brightness.dark,
              );
            }

            return Obx(
              () => GetMaterialApp(
                locale: TranslationProvider.of(context).flutterLocale,
                builder: _buildToast,
                debugShowCheckedModeBanner: false,
                supportedLocales: AppLocaleUtils.supportedLocales,
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
                initialRoute: AppRoutes.splash,
                defaultTransition: Transition.native,
                getPages: AppPages.pages,
                navigatorObservers: [
                  MediaDetailPage.routeObserver,
                ],
                theme: ThemeData(
                  colorScheme: lightColorScheme,
                  useMaterial3: true,
                ).copyWith(
                  actionIconTheme: ActionIconThemeData(
                    backButtonIconBuilder: (BuildContext context) =>
                        const Icon(Icons.arrow_back),
                  ),
                ),
                darkTheme: ThemeData(
                  colorScheme: darkColorScheme,
                  useMaterial3: true,
                ).copyWith(
                  actionIconTheme: ActionIconThemeData(
                    backButtonIconBuilder: (BuildContext context) =>
                        const Icon(Icons.arrow_back),
                  ),
                ),
                themeMode: _configService.themeMode,
              ),
            );
          }),
        );

    return mainApp();
  }
}
