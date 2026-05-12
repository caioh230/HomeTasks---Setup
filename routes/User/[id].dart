import 'package:dart_frog/dart_frog.dart';
import 'package:user/src/User/models/UserModel.dart';
import 'package:user/src/User/services/UserService.dart';

//-----------------------------
//            main
//-----------------------------
///Responsável por receber as requisições com identificador
Future<dynamic> onRequest(RequestContext context, String id) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
        return readUser(id, context);
      case HttpMethod.put:
        return updateUser(id, context);
      case HttpMethod.delete:
        return deleteUser(id, context);
      
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
//            Read
//-----------------------------
///Responsável por executar a requisição de leitura
Future<dynamic> readUser(String id, RequestContext context) async{
    try{
      final service = context.read<UserService>();
      
      return service.readUser(id, context);
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Update
//-----------------------------
///Responsável por executar a requisição de atualização
Future<Response> updateUser(String id, RequestContext context)async{
    try{
      final service = context.read<UserService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateUser(id, UserModel.toModel(data));
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
///Responsável por executar a requisição de remoção
Future<Response> deleteUser(String id, RequestContext context)async{
    try{
      final service = context.read<UserService>();

      return service.deleteUser(id);
    }catch(e){
      throw Exception(e);
    }
}
