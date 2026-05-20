import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

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
        final jwt = JWT.verify(header!, SecretKey('secret passphrase'));
        
        return handler(context);

      } catch (ex) {
        return Response.json(
          statusCode: HttpStatus.badRequest, 
          body:'Identificação de usuário não válida'
        );
      }
    }
  };
}
