import 'package:dart_frog/dart_frog.dart';
import 'package:user/src/User/models/UserModel.dart';
import 'package:user/src/User/services/UserService.dart';

//-----------------------------
//            main
//-----------------------------
Future<dynamic> onRequest(RequestContext context, String id) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
        return readUser(int.parse(id), context);
      case HttpMethod.put:
        return updateUser(int.parse(id), context);
      case HttpMethod.delete:
        return deleteUser(int.parse(id), context);
      
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
Future<dynamic> readUser(int id, RequestContext context) async{
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
Future<Response> updateUser(int id, RequestContext context)async{
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
Future<Response> deleteUser(int id, RequestContext context)async{
    try{
      final service = context.read<UserService>();

      return service.deleteUser(id);
    }catch(e){
      throw Exception(e);
    }
}