import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ForgotPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ForgotPassword/services/ForgotPasswordService.dart';

//-----------------------------
//            main
//-----------------------------
///Responsável por receber as requisições
Future<Response> onRequest(
  RequestContext context
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
          return getForgotPassword(context);
        case HttpMethod.post:
          return createForgotPassword(context);
        case HttpMethod.put:
        case HttpMethod.delete:
        case HttpMethod.head:
        case HttpMethod.options:
        case HttpMethod.patch:

        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Create
//-----------------------------
///Responsável por executar a requisição de criação
Future<Response> createForgotPassword(
  RequestContext context
  )async{
    try{
      final service = context.read<ForgotPasswordService>();
      final data = await context.request.json() as Map<String, dynamic>;

      return service.createForgotPassword(
        ForgotPasswordModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            GET
//-----------------------------
///Responsável por executar a requisição de atualização
Future<Response> getForgotPassword(
  RequestContext context
  )async{
    try{
      final service = context.read<ForgotPasswordService>();
      final data = context.request.uri.queryParameters;

      return service.getForgotPassword(
        ForgotPasswordModel.toModel(data),
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
