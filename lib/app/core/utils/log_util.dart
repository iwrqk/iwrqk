import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LogUtil {
  static late Logger logger;
  static late FileOutput fileOutput;

  static Future<Directory?> get downloadDirectory async {
    if (Platform.isAndroid) {
      return getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    } else {
      return getApplicationDocumentsDirectory();
    }
  }

  static Future<void> init() async {
    if (!kDebugMode) {
      String logPath = await downloadDirectory.then((value) {
        return path.join(
          value!.path,
          "logs",
          "${DateTime.now().toIso8601String()}.log",
        );
      });
      await Directory(path.dirname(logPath)).create(recursive: true);
      fileOutput = FileOutput(file: File(logPath));
    }

    logger = Logger(
      printer: kDebugMode
          ? PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 8,
              lineLength: 120,
              colors: true,
              printEmojis: true,
              printTime: true,
            )
          : SimplePrinter(),
      level: kDebugMode ? Level.verbose : Level.error,
      output: kDebugMode ? ConsoleOutput() : fileOutput,
    );
  }
}

class FileOutput extends LogOutput {
  final File file;
  FileOutput({required this.file}) {
    _sink = file.openWrite(mode: FileMode.append);
  }

  IOSink? _sink;

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines.map((e) => e.toString()).toList(), "\n");
    _sink?.write("\n");
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
