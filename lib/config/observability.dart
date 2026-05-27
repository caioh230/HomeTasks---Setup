import 'dart:io';
import 'package:logging/logging.dart';

class Observability {
  static Future<void> initialize() async {
    _setupLogger();
  }

  static void _setupLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final entry = <String, dynamic>{
        'timestamp': record.time.toIso8601String(),
        'level': record.level.name,
        'logger': record.loggerName,
        'message': record.message,
      };
      if (record.error != null) entry['error'] = record.error.toString();
      if (record.stackTrace != null) entry['stack'] = record.stackTrace.toString();
      stdout.writeln(entry);
    });
  }
}