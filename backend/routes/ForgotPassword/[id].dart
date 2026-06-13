import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ForgotPassword/services/ForgotPasswordService.dart';

//-----------------------------
//            main
//-----------------------------
///Responsável por receber as requisições com identificador
Future<dynamic> onRequest(
  RequestContext context, 
  String id
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
        case HttpMethod.put:
        case HttpMethod.delete:
        case HttpMethod.post:
        case HttpMethod.head:
        case HttpMethod.options:
        case HttpMethod.patch:
      }
    }catch(e){
      throw Exception(e);
    }
}
