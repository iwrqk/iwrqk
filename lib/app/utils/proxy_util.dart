import 'dart:io';

import '../data/providers/storage_provider.dart';

class ProxyUtil {
  static void init() {
    if (StorageProvider.config[StorageKey.proxyEnable] ?? false) {
      String? proxyHost = StorageProvider.config[StorageKey.proxyHost];
      String? proxyPort = StorageProvider.config[StorageKey.proxyPort];

      if (proxyHost != null && proxyPort != null) {
        HttpOverrides.global = ProxiedHttpOverrides(proxyHost, proxyPort);
      }
    }
  }
}

class ProxiedHttpOverrides extends HttpOverrides {
  final String _port;
  final String _host;

  ProxiedHttpOverrides(this._host, this._port);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY $_host:$_port;";
      };
  }
}
