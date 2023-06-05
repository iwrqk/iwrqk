import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/intl_localizations.dart';

class L10n {
  static List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static const Map<String, String> languageMap = {
    'en': 'English',
    'ja': '日本語',
    'zh_CN': '简体中文',
    'zh_TW': '繁體中文',
  };
}
