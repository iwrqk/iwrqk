import 'dart:convert';

import 'package:crypto/crypto.dart';

abstract class CryptoUtil {
  static String getHash(String data) {
    return sha1.convert(utf8.encode(data)).toString();
  }
}
