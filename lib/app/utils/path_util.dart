import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PathUtil {
  static late Directory tempDir;

  /// visible on ios&windows&macos
  static Directory? appDocDir;

  /// visible on windows
  static Directory? appSupportDir;

  /// visible on android
  static Directory? externalStorageDir;

  static Directory? systemDownloadDir;

  static Future<void> init() async {
    await Future.wait([
      getTemporaryDirectory().then((value) => tempDir = value),
      getApplicationDocumentsDirectory().then((value) => appDocDir = value),
      getApplicationSupportDirectory().then((value) => appSupportDir = value),
      getExternalStorageDirectory()
          .then((value) => externalStorageDir = value)
          .catchError((error) => null),
      getDownloadsDirectory()
          .then((value) => systemDownloadDir = value)
          .catchError((error) => null),
    ]);
  }

  static Directory getVisibleDir() {
    if (Platform.isAndroid && externalStorageDir != null) {
      return externalStorageDir!;
    }
    if (GetPlatform.isWindows && appSupportDir != null) {
      return appSupportDir!;
    }
    if (GetPlatform.isLinux && appSupportDir != null) {
      return appSupportDir!;
    }
    return appDocDir ?? appSupportDir ?? systemDownloadDir!;
  }
}
