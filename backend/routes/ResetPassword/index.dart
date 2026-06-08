import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ResetPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/services/ResetPasswordService.dart';

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
        case HttpMethod.post:
          return createResetPassword(context);

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
Future<Response> createResetPassword(
  RequestContext context
  )async{
    try{
      final service = context.read<ResetPasswordService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createResetPassword(
        ForgotPasswordModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
