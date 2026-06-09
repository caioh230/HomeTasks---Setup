import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:dotenv/dotenv.dart';

class Observability {
  static String _lokiUrl = '';
  static String _lokiUser = '';
  static String _lokiApiKey = '';
  static String _appEnv = 'development';

  static Future<void> initialize(DotEnv env) async {
    _lokiUrl    = env['LOKI_URL'] ?? '';
    _lokiUser   = env['LOKI_USER'] ?? '';
    _lokiApiKey = env['LOKI_API_KEY'] ?? '';
    _appEnv     = env['APP_ENV'] ?? 'development';

    // Temporário para confirmar que carregou
    stdout.writeln('>>> LOKI_URL carregado: $_lokiUrl');

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

      if (_lokiUrl.isNotEmpty) {
        _sendToLoki(record, entry);
      }
    });
  }

  static void _sendToLoki(LogRecord record, Map<String, dynamic> entry) {
    final uri = Uri.parse('$_lokiUrl/loki/api/v1/push');
    final auth = base64Encode(utf8.encode('$_lokiUser:$_lokiApiKey'));
    final timestampNs = (record.time.microsecondsSinceEpoch * 1000).toString();

    final body = jsonEncode({
      'streams': [
        {
          'stream': {
            'app': 'hometasks',
            'env': _appEnv,
            'level': record.level.name,
            'logger': record.loggerName,
          },
          'values': [
            [timestampNs, jsonEncode(entry)],
          ],
        }
      ]
    });

    http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $auth',
      },
      body: body,
    ).then((response) {
      stdout.writeln('Loki response: ${response.statusCode} ${response.body}');
    }).catchError((e) {
      stdout.writeln('Loki send error: $e');
    });
  }
}