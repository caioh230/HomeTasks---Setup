import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

final _log = Logger('health');

Future<Response> onRequest(RequestContext context) async {
  _log.info({'event': 'health_check', 'method': context.request.method.value}.toString());
  _log.warning({'event': 'health_warning_test', 'msg': 'testando nível warning'}.toString());
  _log.severe({'event': 'health_error_test', 'msg': 'testando nível error'}.toString());

  return Response.json(body: {
    'status': 'ok',
    'timestamp': DateTime.now().toIso8601String(),
    'service': 'hometasks',
  });
}