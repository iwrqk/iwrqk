import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LogUtil {
  static late Logger logger;
  static late FileOutput fileOutput;

  static Future<void> init() async {
    if (!kDebugMode) {
      String logPath = await getApplicationDocumentsDirectory().then((value) {
        return path.join(
          value.path,
          "logs",
          "${DateTime.now().toIso8601String()}.log",
        );
      });
      await Directory(path.dirname(logPath)).create(recursive: true);
      fileOutput = FileOutput(directory: logPath);
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
  final String directory;
  FileOutput({required this.directory});

  File? _file;

  @override
  void output(OutputEvent event) async {
    _file ??= File(directory);

    if (!_file!.existsSync()) {
      _file = await _file!.writeAsString(
        "${event.lines.join("\n")}\n",
        mode: FileMode.append,
      );
    }
  }
}
