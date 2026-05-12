import 'package:dart_frog/dart_frog.dart';

import 'package:user/src/User/models/UserModel.dart';
import 'package:user/src/User/services/UserService.dart';

//-----------------------------
//            main
//-----------------------------
///Responsável por receber as requisições
Future<Response> onRequest(RequestContext context) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
        return isUser(context);
      case HttpMethod.post:
        return createUser(context);

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
//            Read
//-----------------------------
///Responsável por executar a requisição de verificação
Future<Response> isUser(RequestContext context) async{
  try{
    final service = context.read<UserService>();

    final data = await context.request.json() as Map<String, dynamic>;

    return await service.isUser(UserModel.toModel(data));
  }catch(e){
    throw Exception(e);
  }
}

//-----------------------------
//            Create
//-----------------------------
///Responsável por executar a requisição de criação
Future<Response> createUser(RequestContext context)async{
  try{
    final service = context.read<UserService>();

    final data = await context.request.json() as Map<String, dynamic>;

    return service.createUser(UserModel.toModel(data));
  }catch(e){
    throw Exception(e);
  }
}
