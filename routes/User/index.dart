import 'package:dart_frog/dart_frog.dart';
import 'package:user/src/User/models/UserModel.dart';
import 'package:user/src/User/services/UserService.dart';

//-----------------------------
//            main
//-----------------------------
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

      throw();
    }
  }catch(e){
    throw Exception(e);
  }
}

//-----------------------------
//            Read
//-----------------------------
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
Future<Response> createUser(RequestContext context)async{
  try{
    final service = await context.read<UserService>();

    final data = await context.request.json() as Map<String, dynamic>;

    return service.createUser(UserModel.toModel(data));
  }catch(e){
    throw Exception(e);
  }
}