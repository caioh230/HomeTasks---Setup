import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/repositories/UserRepository.dart';

///Serviço responsável como intermediário entre as requisições e o repository
class UserService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Requisição de criação de nova instância
  Future<Response> createUser(UserModel user) async {
    try{
      return UserRepository().createUser(user);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Requisição de leitura de instância
  Future<Response> readUser(String id, RequestContext context) async{
    try{
      return UserRepository().readUser(id);

    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Requisição de verificação de instância
  Future<Response> isUser(UserModel user) async{
    try{
      return UserRepository().isUser(user);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Requisição de atualização de instância
  Future<Response> updateUser(String id, UserModel user) async{
    try{
      return UserRepository().updateUser(id, user);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Requisição de remoção de instância
  Future<Response> deleteUser(String id) async{
    try{
      return UserRepository().deleteUser(id);
    }catch(e){
      throw Exception(e);
    }
  }
}
