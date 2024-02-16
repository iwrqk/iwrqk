import 'dart:io';

import 'package:intl/intl.dart';
import 'package:iwrqk/app/utils/path_util.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import '../data/providers/storage_provider.dart';
import 'display_util.dart';

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (StorageProvider.config
        .get(StorageKey.verboseLoggingEnable, defaultValue: false)) {
      return event.level.index >= level!.index;
    }
    return event.level.index >= level!.index && event.level != Level.trace;
  }
}

class LogUtil {
  static Logger? _consoleLogger;
  static Logger? _verboseFileLogger;
  static Logger? _warningFileLogger;
  static Logger? _downloadFileLogger;
  static late File _waringLogFile;
  static late File _downloadLogFile;

  static final String logDirPath =
      path.join(PathUtil.getVisibleDir().path, 'logs');

  static Future<void> init() async {
    if (!StorageProvider.config
        .get(StorageKey.loggingEnable, defaultValue: true)) {
      return;
    }

    if (!Directory(logDirPath).existsSync()) {
      Directory(logDirPath).createSync();
    }

    LogPrinter devPrinter =
        PrettyPrinter(stackTraceBeginIndex: 0, methodCount: 6);
    LogPrinter prodPrinterWithBox = PrettyPrinter(
        stackTraceBeginIndex: 0,
        methodCount: 6,
        colors: false,
        printTime: true);
    LogPrinter prodPrinterWithoutBox = PrettyPrinter(
        stackTraceBeginIndex: 0,
        methodCount: 6,
        colors: false,
        noBoxingByDefault: true);

    _consoleLogger = Logger(printer: devPrinter);

    _verboseFileLogger = Logger(
      printer: HybridPrinter(prodPrinterWithBox,
          trace: prodPrinterWithoutBox,
          debug: prodPrinterWithoutBox,
          info: prodPrinterWithoutBox),
      filter: _LogFilter(),
      output: FileOutput(
          file: File(path.join(logDirPath,
              '${DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now())}.log'))),
    );

    if (StorageProvider.config
        .get(StorageKey.verboseLoggingEnable, defaultValue: false)) {
      _waringLogFile = File(path.join(logDirPath,
          '${DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now())}_error.log'));
      _warningFileLogger = Logger(
        level: Level.warning,
        printer: prodPrinterWithBox,
        filter: ProductionFilter(),
        output: FileOutput(file: _waringLogFile),
      );

      _downloadLogFile = File(path.join(logDirPath,
          '${DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now())}_download.log'));
      _downloadFileLogger = Logger(
        printer: prodPrinterWithoutBox,
        filter: ProductionFilter(),
        output: FileOutput(file: _downloadLogFile),
      );
    }

    debug('init LogUtil success', false);
  }

  /// For actions that print params
  static void verbose(Object? msg, [bool withStack = false]) {
    _consoleLogger?.t(msg, stackTrace: withStack ? null : StackTrace.empty);
    _verboseFileLogger?.t(msg, stackTrace: withStack ? null : StackTrace.empty);
  }

  /// For actions that is invisible to user
  static void debug(Object? msg, [bool withStack = false]) {
    _consoleLogger?.d(msg, stackTrace: withStack ? null : StackTrace.empty);
    _verboseFileLogger?.d(msg, stackTrace: withStack ? null : StackTrace.empty);
  }

  /// For actions that is visible to user
  static void info(Object? msg, [bool withStack = false]) {
    _consoleLogger?.i(msg, stackTrace: withStack ? null : StackTrace.empty);
    _verboseFileLogger?.i(msg, stackTrace: withStack ? null : StackTrace.empty);
  }

  static void warning(Object? msg, [Object? error, StackTrace? stackTrace]) {
    _consoleLogger?.w(msg, error: error, stackTrace: stackTrace);
    _verboseFileLogger?.w(msg, error: error, stackTrace: stackTrace);
    _warningFileLogger?.w(msg, error: error, stackTrace: stackTrace);
  }

  static void error(Object? msg, [Object? error, StackTrace? stackTrace]) {
    _consoleLogger?.e(msg, error: error, stackTrace: stackTrace);
    _verboseFileLogger?.e(msg, error: error, stackTrace: stackTrace);
    _warningFileLogger?.e(msg, error: error, stackTrace: stackTrace);
  }

  static void download(Object? msg) {
    _consoleLogger?.t(msg, stackTrace: StackTrace.empty);
    _downloadFileLogger?.t(msg, stackTrace: StackTrace.empty);
  }

  static Future<String> getSize() async {
    Directory logDirectory = Directory(logDirPath);

    return logDirectory
        .exists()
        .then<int>((exist) {
          if (!exist) {
            return 0;
          }

          return logDirectory.list().fold<int>(
              0,
              (previousValue, element) =>
                  previousValue += (element as File).lengthSync());
        })
        .then<String>(
            (totalBytes) => DisplayUtil.getDisplayFileSizeWithUnit(totalBytes))
        .onError((e, stackTrace) {
          LogUtil.error('getSizeFailed', error, stackTrace);
          return 'N/A';
        });
  }

  static Future<void> clear() {
    _verboseFileLogger?.close();
    _warningFileLogger?.close();
    _downloadFileLogger?.close();

    _verboseFileLogger = null;
    _warningFileLogger = null;
    _downloadFileLogger = null;

    /// need to wait for log file close
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (Directory(logDirPath).existsSync()) {
          Directory(logDirPath).deleteSync(recursive: true);
        }
      },
    );
  }
}
