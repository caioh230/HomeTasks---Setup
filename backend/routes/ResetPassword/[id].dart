import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/ResetPassword/models/ResetPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/services/ResetPasswordService.dart';

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
          return updateResetPassword(id, context);
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
Future<Response> updateResetPassword(
  String id, 
  RequestContext context
  )async{
    try{
      final service = context.read<ResetPasswordService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateResetPassword(
        id,
        ResetPasswordModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
