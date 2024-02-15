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

  static const String downloadDirectory = "downloadDirectory";
  static const String allowMediaScan = "allowMediaScan";

  static const String proxyEnable = "proxyEnable";
  static const String proxyHost = "proxyHost";
  static const String proxyPort = "proxyPort";
}

abstract class PLPlayerConfigKey {
  static const String fullScreenMode = 'fullScreenMode';
  static const String cacheVideoFit = 'cacheVideoFit';
  static const String playSpeedDefault = 'playSpeedDefault';
  static const String longPressSpeedDefault = 'longPressSpeedDefault';
  static const String qualityIndexSaved = 'qualityIndexSaved';

  static const String enableQuickDouble = 'enableQuickDouble';
  static const String enableBackgroundPlay = 'enableBackgroundPlay';
  static const String enableAutoLongPressSpeed = 'enableAutoLongPressSpeed';
  static const String enableAutoPlay = 'enableAutoPlay';
  static const String enableHA = 'enableHA';
  static const String enableAutoEnter = 'enableAutoEnter';
  static const String enableAutoBrightness = 'enableAutoBrightness';
  static const String enableAutoExit = 'enableAutoExit';
}

class GStorageConfig {
  final GetStorage storage;

  GStorageConfig(this.storage);

  Map<String, dynamic>? getAll() {
    String? settingsJson = storage.read(StorageKey.config);
    if (settingsJson == null) return null;
    return jsonDecode(settingsJson);
  }

  Future<void> set(String key, dynamic value) async {
    Map<String, dynamic> settings = getAll() ?? {};
    settings[key] = value;
    return await storage.write(StorageKey.config, jsonEncode(settings));
  }

  dynamic get(String key, {dynamic defaultValue}) {
    Map<String, dynamic>? settings = getAll();
    if (settings == null) return defaultValue;
    return settings[key] ?? defaultValue;
  }

  dynamic operator [](String key) => get(key);

  void operator []=(String key, dynamic value) => set(key, value);
}

class GStorageRecord<T> {
  final GetStorage storage;
  final String key;
  final T Function(Map<String, dynamic> json) fact;
  final bool Function(T newItem, T oldItem)? compare;

  GStorageRecord(this.storage, this.key, this.fact, this.compare);

  List<T> get() {
    String? recordsJson = storage.read(key);
    return recordsJson == null
        ? []
        : (jsonDecode(recordsJson) as List<dynamic>)
            .where((item) => item != null)
            .map((item) => fact(item as Map<String, dynamic>))
            .toList();
  }

  T operator [](int index) => get()[index];

  Future<void> set(List<T> records) async {
    return await storage.write(key, jsonEncode(records));
  }

  Future<void> add(T newItem) async {
    List<T> records = get();
    if (records.isNotEmpty) {
      records.removeWhere((item) => compare!(newItem, item));
    }
    List<T> list = [newItem];
    list.addAll(records);
    await set(list);
  }

  Future<void> update(T oldItem, T newItem) async {
    List<T> list = get();
    int index = list.indexWhere((element) => element == oldItem);
    list[index] = newItem;
    await set(list);
  }

  Future<void> updateWhere(bool Function(T item) test, T newItem) async {
    List<T> list = get();
    int index = list.indexWhere(test);
    list[index] = newItem;
    await set(list);
  }

  Future<void> delete(T item) async {
    List<T> list = get();
    list.remove(item);
    await set(list);
  }

  Future<void> deleteWhere(bool Function(T item) test) async {
    List<T> list = get();
    list.removeWhere(test);
    await set(list);
  }

  Future<void> deleteByIndex(int index) async {
    List<T> list = get();
    list.removeAt(index);
    await set(list);
  }

  bool contains(T item) {
    List<T> list = get();
    return list.contains(item);
  }

  bool containsWhere(bool Function(T item) test) {
    List<T> list = get();
    return list.any(test);
  }

  Future<void> clean() async {
    await set([]);
  }
}

class SecStorageObject {
  final FlutterSecureStorage storage;
  final String key;

  SecStorageObject(this.storage, this.key);

  Future<String?> get() async {
    return await storage.read(key: key);
  }

  Future<void> set(String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> delete() async {
    return await storage.delete(key: key);
  }
}

class SecStorageMap {
  final FlutterSecureStorage storage;
  final String key;

  SecStorageMap(this.storage, this.key);

  Future<Map<String, dynamic>?> get() async {
    String? json = await storage.read(key: key);
    if (json == null) return null;
    return jsonDecode(json);
  }

  Future<void> set(Map<String, dynamic> value) async {
    return await storage.write(key: key, value: jsonEncode(value));
  }

  Future<void> delete() async {
    return await storage.delete(key: key);
  }

  dynamic getByKey(String key) async {
    Map<String, dynamic>? map = await get();
    if (map == null) return null;
    return map[key];
  }

  dynamic operator [](String key) => getByKey(key);

  void operator []=(String key, dynamic value) async {
    Map<String, dynamic> map = await get() ?? {};
    map[key] = value;
    set(map);
  }
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
  static SecStorageObject userToken =
      SecStorageObject(_secureStorage, StorageKey.userToken);

  // Saved email & password
  static SecStorageMap savedUserAccountPassword =
      SecStorageMap(_secureStorage, StorageKey.savedUserAccountPassword);

  // Lock screen password & enable biometrics Auth
  static SecStorageMap autoLockConfig =
      SecStorageMap(_secureStorage, StorageKey.autoLockConfig);

  // Config
  static GStorageConfig config = GStorageConfig(_storage);

  // History
  static GStorageRecord<HistoryMediaModel> historyList = GStorageRecord(
    _storage,
    StorageKey.historyList,
    HistoryMediaModel.fromJson,
    (HistoryMediaModel newItem, HistoryMediaModel oldItem) =>
        newItem.id == oldItem.id,
  );

  // Search history
  static GStorageRecord<SearchHistoryModel> searchHistoryList = GStorageRecord(
    _storage,
    StorageKey.searchHistoryList,
    SearchHistoryModel.fromJson,
    (SearchHistoryModel newItem, SearchHistoryModel oldItem) =>
        newItem.keyword == oldItem.keyword,
  );

  // Download Video Records
  static GStorageRecord<VideoDownloadTask> downloadVideoRecords =
      GStorageRecord(
    _storage,
    StorageKey.downloadVideoRecords,
    VideoDownloadTask.fromJson,
    (VideoDownloadTask newItem, VideoDownloadTask oldItem) =>
        newItem.taskId == oldItem.taskId,
  );
}
