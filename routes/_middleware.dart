import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

///Importação de dados sensíveis
final env = DotEnv()..load();

Handler middleware(Handler handler) {
  return(context){
    final request = context.request;
    final header = request.headers['authorization'];
    
    if(
      context.request.method.value == 'GET' 
      && 
      context.request.url.toString() == 'User'
    ){
      return handler(context);
    }else{
      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(
          header!, 
          SecretKey(env['jwtSecretKey'].toString())
        );

        if(jwt.header!.isEmpty){
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body:'Identificação de usuário não válida'
          );
        }else{
          return handler(context);
        }
      } catch (ex) {
        return Response.json(
          statusCode: HttpStatus.badRequest, 
          body:'Identificação de usuário não válida'
        );
      }
    }
  };
}
