import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();

Handler middleware(Handler handler) {
  return (context) {
    final request = context.request;

    // Permite criação de usuário sem autenticação
    if (
      request.uri.path.startsWith('/User') &&
      request.method == HttpMethod.post
    ) {
      return handler(context);
    }

    try {
      final authHeader = request.headers['authorization'];

      if (authHeader == null) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {
            'error': 'Authorization não informado',
          },
        );
      }

      if (!authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {
            'error': 'Formato de token inválido',
          },
        );
      }

      final token = authHeader.substring('Bearer '.length);

      if (token.isEmpty) {
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

      return handler(context);
    } catch (e, s) {
      print('Erro ao validar JWT: $e');
      print(s);

      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'error': 'Token inválido',
        },
      );
    }
  };
}