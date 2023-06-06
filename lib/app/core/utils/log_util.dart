import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LogUtil {
  static late Logger logger;

  static Future<void> init() async {
    String logPath = await getApplicationDocumentsDirectory().then((value) {
      return path.join(
        value.path,
        "logs",
        "${DateTime.now().toIso8601String()}.log",
      );
    });

    if (!kDebugMode) {
      await Directory(path.dirname(logPath)).create(recursive: true);
    }

    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: kDebugMode ? Level.verbose : Level.error,
      output: kDebugMode ? ConsoleOutput() : FileOutput(directory: logPath),
    );
  }
}

class FileOutput extends LogOutput {
  final String directory;
  FileOutput({required this.directory});

  late File _file;
  IOSink? _sink;

  @override
  void init() {
    _file = File(directory);

    _sink = _file.openWrite(
      mode: FileMode.writeOnlyAppend,
      encoding: utf8,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
    _sink?.write('\n');
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();

    if (await _file.length() == 0) {
      await _file.delete();
    }
  }
}
