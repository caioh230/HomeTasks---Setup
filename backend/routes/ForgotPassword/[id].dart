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
          return getForgotPassword(id, context);
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

//-----------------------------
//            Update
//-----------------------------
///Responsável por executar a requisição de atualização
Future<Response> getForgotPassword(
  String id, 
  RequestContext context
  )async{
    try{
      final service = context.read<ForgotPasswordService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.getForgotPassword(
        id,
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
