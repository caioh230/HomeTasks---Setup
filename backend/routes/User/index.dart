import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/services/UserService.dart';

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
          return getUser(context);
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
Future<Response> getUser(RequestContext context) async {
  try {
    final service = context.read<UserService>();

    final authHeader = context.request.headers['authorization'];

    //jwt login
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        statusCode: 401,
        body: 'Missing token',
      );
    }

    final token = authHeader.substring('Bearer '.length);

    return await service.isUserByToken(token, context);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: 'Error: $e',
    );
  }
}

//-----------------------------
//            Create
//-----------------------------
///Responsável por executar a requisição de criação
Future<Response> createUser(
  RequestContext context
  )async{
    try{
      final service = context.read<UserService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createUser(
        UserModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
