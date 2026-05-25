import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/repositories/UserRepository.dart';

///Importação de dados sensíveis
final env = DotEnv()..load();

///Serviço responsável como intermediário entre as requisições e o repository
class UserService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Requisição de criação de nova instância
  Future<Response> createUser(
    UserModel user, 
    RequestContext context
    ) async {
      try{
        final repository = context.read<UserRepository>();

        return repository.createUser(user);
      }catch(e){
        throw Exception(e);
      }
    }

  //-----------------------------
  //            read
  //-----------------------------
  ///Requisição de leitura de instância
  Future<Response> readUser(
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        if(validateid(id, context)){
          return repository.readUser(id);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Requisição de verificação de instância
  Future<Response> isUser(
    UserModel user, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        return repository.isUser(user);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Requisição de atualização de instância
  Future<Response> updateUser(
    String id, 
    UserModel user, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        if(validateid(id, context)){
          return repository.updateUser(id, user);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Requisição de remoção de instância
  Future<Response> deleteUser(
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        if(validateid(id, context)){        
          return repository.deleteUser(id);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }
}

//-----------------------------
//            RLS
//-----------------------------
///Garante que o usuário só altere as próprias coleções
bool validateid(
  String id, 
    RequestContext context
  ){
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
  
    if(payload['id'].toString() == id){
      return true;
    }
    else{
      return false;
    }
}
