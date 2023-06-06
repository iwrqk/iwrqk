import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/intl_localizations.dart';

import '../../../l10n.dart';

abstract class DisplayUtil {
  static late AppLocalizations l10n;

  static String get cancel => l10n.cancel;
  static String get authenticateRequired => l10n.authenticate_required;

  static String get messageNeedLogin => l10n.message_require_login;
  static String get messageAuthenticateToContinue =>
      l10n.message_authenticate_to_continue;
  static String get messageAuthenticateToEnableBiometric =>
      l10n.message_authenticate_to_enable_biometric;
  static String get messageNoStoragePermission =>
      l10n.message_no_provide_storage_permission;
  static String get messageDownloadTaskAlreadyExist =>
      l10n.message_download_task_already_exists;

  static String get downloadDownloading => l10n.download_downloading;
  static String get downloadPaused => l10n.download_paused;
  static String get downloadFailed => l10n.download_failed;
  static String get downloadFinished => l10n.download_finished;

  static void init(BuildContext context) {
    l10n = L10n.of(context);
  }

  static void reset(BuildContext context) {
    init(context);
  }

  static String getErrorMessage(String message) {
    switch (message) {
      case "errors.invalidLogin":
        return l10n.error_invalid_login;
      case "errors.invalidCaptcha":
        return l10n.error_invalid_captcha;
      default:
        return message;
    }
  }

  static String getDisplayDate(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return l10n.time_seconds_ago("${difference.inSeconds}");
    } else if (difference.inMinutes < 60) {
      return l10n.time_minutes_ago("${difference.inMinutes}");
    } else if (difference.inHours < 24) {
      return l10n.time_hours_ago("${difference.inHours}");
    } else if (difference.inDays < 10) {
      return l10n.time_days_ago("${difference.inDays}");
    } else {
      return DateFormat.yMd(l10n.localeName).format(dateTime);
    }
  }

  static String getDisplayTime(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return l10n.time_seconds_ago("${difference.inSeconds}");
    } else if (difference.inMinutes < 60) {
      return l10n.time_minutes_ago("${difference.inMinutes}");
    } else if (difference.inHours < 24) {
      return l10n.time_hours_ago("${difference.inHours}");
    } else if (difference.inDays < 10) {
      return l10n.time_days_ago("${difference.inDays}");
    } else {
      return DateFormat.yMd(l10n.localeName).add_Hms().format(dateTime);
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
    return DateFormat.yMd(l10n.localeName).add_Hms().format(dateTime);
  }

  static String compactBigNumber(int number) {
    return NumberFormat.compact(locale: l10n.localeName).format(number);
  }

  static String formatNumberWithCommas(int number) {
    return NumberFormat("#,###").format(number);
  }
}
