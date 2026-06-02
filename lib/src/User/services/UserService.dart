import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/repositories/UserRepository.dart';


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
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        return repository.readUser(context);
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
    UserModel user, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();

        return repository.updateUser(context, user);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Requisição de remoção de instância
  Future<Response> deleteUser(
    RequestContext context
    ) async{
      try{
        final repository = context.read<UserRepository>();
  
        return repository.deleteUser(context);
      }catch(e){
        throw Exception(e);
      }
  }
}
