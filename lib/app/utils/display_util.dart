import 'package:intl/intl.dart';

import 'package:iwrqk/i18n/strings.g.dart';

abstract class DisplayUtil {
  static String getLocalecode() =>
      LocaleSettings.currentLocale.flutterLocale.toLanguageTag();

  static String getErrorMessage(String message) {
    switch (message) {
      case "errors.invalidLogin":
        return t.error.account.invalid_login;
      case "errors.invalidCaptcha":
        return t.error.account.invalid_captcha;
      default:
        return message;
    }
  }

  static String getDisplayDate(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return t.time.seconds_ago(time: "${difference.inSeconds}");
    } else if (difference.inMinutes < 60) {
      return t.time.minutes_ago(time: "${difference.inMinutes}");
    } else if (difference.inHours < 24) {
      return t.time.hours_ago(time: "${difference.inHours}");
    } else if (difference.inDays < 10) {
      return t.time.days_ago(time: "${difference.inDays}");
    } else {
      return DateFormat.yMd(getLocalecode()).format(dateTime);
    }
  }

  static String getDisplayTime(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return t.time.seconds_ago(time: "${difference.inSeconds}");
    } else if (difference.inMinutes < 60) {
      return t.time.minutes_ago(time: "${difference.inMinutes}");
    } else if (difference.inHours < 24) {
      return t.time.hours_ago(time: "${difference.inHours}");
    } else if (difference.inDays < 10) {
      return t.time.days_ago(time: "${difference.inDays}");
    } else {
      return DateFormat.yMd(getLocalecode()).add_Hms().format(dateTime);
    }
  }

  static String getDownloadFileSizeProgress(int downloaded, int total) {
    if (total == 0) {
      return "0.0/0.0 MB";
    }
    double downloadedKB = downloaded / 1024;
    double downloadedMB = downloaded / 1024 / 1024;
    double downloadedGB = downloaded / 1024 / 1024 / 1024;
    double totalKB = total / 1024;
    double totalMB = total / 1024 / 1024;
    double totalGB = total / 1024 / 1024 / 1024;

    if (totalMB < 1) {
      return "${downloadedKB.toStringAsFixed(1)} / ${totalKB.toStringAsFixed(1)} KB";
    } else if (totalGB < 1) {
      return "${downloadedMB.toStringAsFixed(1)} / ${totalMB.toStringAsFixed(1)} MB";
    } else {
      return "${downloadedGB.toStringAsFixed(1)} / ${totalGB.toStringAsFixed(1)} GB";
    }
  }

  static String getDisplayFileSizeWithUnit(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return "$sizeInBytes B";
    } else if (sizeInBytes < 1024 * 1024) {
      return "${(sizeInBytes / 1024).toStringAsFixed(1)} KB";
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return "${(sizeInBytes / 1024 / 1024).toStringAsFixed(1)} MB";
    } else {
      return "${(sizeInBytes / 1024 / 1024 / 1024).toStringAsFixed(1)} GB";
    }
  }

  static String getDetailedTime(DateTime dateTime) {
    return DateFormat.yMd(getLocalecode()).add_Hms().format(dateTime);
  }

  static String compactBigNumber(int number) {
    return NumberFormat.compact(locale: getLocalecode()).format(number);
  }

  static String formatNumberWithCommas(int number) {
    return NumberFormat("#,###").format(number);
  }
}
