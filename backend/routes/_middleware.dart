import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logging/logging.dart';

final env = DotEnv()..load();

final _log = Logger('AuthMiddleware');

Handler middleware(Handler handler) {
  return (context) async {
    final request = context.request;

    // Permite criação de usuário sem autenticação
    if (
      request.uri.path.startsWith('/User') &&
      request.method == HttpMethod.post
    ) {
      _log.info({
        'event': 'public_route_access',
        'method': request.method.value,
        'path': request.uri.path,
      }.toString());

      return handler(context);
    }

    try {
      _log.info({
        'event': 'authentication_started',
        'method': request.method.value,
        'path': request.uri.path,
      }.toString());

      final authHeader = request.headers['authorization'];

      if (authHeader == null) {
        _log.warning({
          'event': 'authorization_header_missing',
          'method': request.method.value,
          'path': request.uri.path,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {
            'error': 'Authorization não informado',
          },
        );
      }

      if (!authHeader.startsWith('Bearer ')) {
        _log.warning({
          'event': 'invalid_token_format',
          'method': request.method.value,
          'path': request.uri.path,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {
            'error': 'Formato de token inválido',
          },
        );
      }

      final token = authHeader.substring('Bearer '.length);

      if (token.isEmpty) {
        _log.warning({
          'event': 'empty_token',
          'method': request.method.value,
          'path': request.uri.path,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {
            'error': 'Token vazio',
          },
        );
      }

      JWT.verify(
        token,
        SecretKey(env['jwtSecretKey'].toString()),
      );

      _log.info({
        'event': 'authentication_success',
        'method': request.method.value,
        'path': request.uri.path,
      }.toString());

      return handler(context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'authentication_failed',
          'method': request.method.value,
          'path': request.uri.path,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'error': 'Token inválido',
        },
      );
    }
  };
}