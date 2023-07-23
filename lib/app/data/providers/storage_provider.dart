import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../models/download_task.dart';
import '../models/offline/history_media.dart';
import '../models/offline/search_history.dart';

abstract class StorageKey {
  static const String config = "config";
  static const String savedUserAccountPassword = "savedUserAccountPassword";
  static const String autoLockConfig = "autoLockConfig";
  static const String userToken = "userToken";
  static const String historyList = "historyList";
  static const String downloadVideoRecords = "downloadVideoRecords";
  static const String downloadImageRecords = "downloadImageRecords";
  static const String searchHistoryList = "searchHistoryList";
}

class StorageProvider {
  static late GetStorage _storage;
  static late FlutterSecureStorage _secureStorage;

  static Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    _secureStorage = const FlutterSecureStorage();
  }

  // User token
  static Future<String?> get userToken =>
      _secureStorage.read(key: StorageKey.userToken);

  static Future<void> setUserToken(String token) async {
    return await _secureStorage.write(key: StorageKey.userToken, value: token);
  }

  static Future<void> cleanUserToken() async {
    return await _secureStorage.delete(key: StorageKey.userToken);
  }

  // Saved email & password
  static Future get savedUserAccountPassword => _secureStorage
      .read(key: StorageKey.savedUserAccountPassword)
      .then((value) => value == null ? null : jsonDecode(value));

  static Future<void> setSavedUserAccountPassword(
      String account, String password) async {
    return await _secureStorage.write(
      key: StorageKey.savedUserAccountPassword,
      value: jsonEncode({"account": account, "password": password}),
    );
  }

  // Lock screen password & enable biometrics Auth
  static Future<void> setAutoLockConfig(String key, dynamic value) async {
    Map<String, dynamic> autoLockConfig = await getAutoLockConfig() ?? {};
    autoLockConfig[key] = value;
    return await _secureStorage.write(
      key: StorageKey.autoLockConfig,
      value: jsonEncode(autoLockConfig),
    );
  }

  static Future<Map<String, dynamic>?> getAutoLockConfig() async {
    String? autoLockConfigJson =
        await _secureStorage.read(key: StorageKey.autoLockConfig);
    if (autoLockConfigJson == null) return null;
    return jsonDecode(autoLockConfigJson);
  }

  static Future<dynamic> getAutoLockConfigByKey(String key) async {
    Map<String, dynamic>? autoLockConfig = await getAutoLockConfig();
    if (autoLockConfig == null) return null;
    return autoLockConfig[key];
  }

  static Future<void> cleanSavedUserEmailPassword() async {
    return await _secureStorage.delete(key: StorageKey.savedUserAccountPassword);
  }

  // config
  static Future<void> setConfig(String key, dynamic value) async {
    Map<String, dynamic> settings = getConfig() ?? {};
    settings[key] = value;
    return await _storage.write(StorageKey.config, jsonEncode(settings));
  }

  static Map<String, dynamic>? getConfig() {
    String? settingsJson = _storage.read(StorageKey.config);
    if (settingsJson == null) return null;
    return jsonDecode(settingsJson);
  }

  static dynamic getConfigByKey(String key) {
    Map<String, dynamic>? settings = getConfig();
    if (settings == null) return null;
    return settings[key];
  }

  // History
  static List<HistoryMediaModel> get historyList {
    String? historyList = _storage.read(StorageKey.historyList);
    return historyList == null
        ? []
        : (jsonDecode(historyList) as List<dynamic>)
            .map((item) => HistoryMediaModel.fromJson(item))
            .toList();
  }

  static Future<void> addHistoryItem(HistoryMediaModel newItem) async {
    List<HistoryMediaModel> histories = historyList;
    if (histories.isNotEmpty) {
      histories.removeWhere((item) => item.id == newItem.id);
    }
    List<HistoryMediaModel> list = [newItem];
    list.addAll(histories);
    return await _storage.write(StorageKey.historyList, jsonEncode(list));
  }

  static Future<void> deleteHistoryItem(int index) async {
    List<HistoryMediaModel> list = historyList;
    list.removeAt(index);
    return await _storage.write(StorageKey.historyList, jsonEncode(list));
  }

  static Future<void> cleanHistoryList() async {
    return await _storage.write(StorageKey.historyList, "[]");
  }

  // Search history
  static List<SearchHistoryModel> get searchHistoryList {
    String? searchHistoryList = _storage.read(StorageKey.searchHistoryList);
    return searchHistoryList == null
        ? []
        : (jsonDecode(searchHistoryList) as List<dynamic>)
            .map((item) => SearchHistoryModel.fromJson(item))
            .toList();
  }

  static Future<void> addSearchHistoryItem(SearchHistoryModel newItem) async {
    List<SearchHistoryModel> histories = searchHistoryList;
    if (histories.isNotEmpty) {
      histories.removeWhere((item) => item.keyword == newItem.keyword);
    }
    List<SearchHistoryModel> list = [newItem];
    list.addAll(histories);
    return await _storage.write(StorageKey.searchHistoryList, jsonEncode(list));
  }

  static Future<void> deleteSearchHistoryItem(int index) async {
    List<SearchHistoryModel> list = searchHistoryList;
    list.removeAt(index);
    return await _storage.write(StorageKey.searchHistoryList, jsonEncode(list));
  }

  static Future<void> cleanSearchHistoryList() async {
    return await _storage.write(StorageKey.searchHistoryList, "[]");
  }

  // Download Video Records
  static List<VideoDownloadTask> get downloadVideoRecords {
    String? downloadVideoRecords =
        _storage.read(StorageKey.downloadVideoRecords);
    return downloadVideoRecords == null
        ? []
        : (jsonDecode(downloadVideoRecords) as List<dynamic>)
            .map((item) => VideoDownloadTask.fromJson(item))
            .toList();
  }

  static Future<void> addDownloadVideoRecord(VideoDownloadTask newItem) async {
    List<VideoDownloadTask> records = downloadVideoRecords;
    if (records.isNotEmpty) {
      records.removeWhere(
          (item) => item.offlineMedia.id == newItem.offlineMedia.id);
    }
    List<VideoDownloadTask> list = [newItem];
    list.addAll(records);
    return await _storage.write(
        StorageKey.downloadVideoRecords, jsonEncode(list));
  }

  static Future<void> deleteDownloadVideoRecord(int index) async {
    List<VideoDownloadTask> list = downloadVideoRecords;
    list.removeAt(index);
    return await _storage.write(
        StorageKey.downloadVideoRecords, jsonEncode(list));
  }

  static Future<void> cleanDownloadVideoRecords() async {
    return await _storage.write(StorageKey.downloadVideoRecords, "[]");
  }
}
