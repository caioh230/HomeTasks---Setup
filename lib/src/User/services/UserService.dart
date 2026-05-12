import 'package:dart_frog/dart_frog.dart';

import 'package:user/src/User/models/UserDBModel.dart';
import 'package:user/src/User/models/UserModel.dart';
import 'package:user/src/User/repositories/UserRepository.dart';

class UserService {
  UserService();

  //-----------------------------
  //            create
  //-----------------------------
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
  Future<Response> deleteUser(String id) async{
    try{
      return UserRepository().deleteUser(id);
    }catch(e){
      throw Exception(e);
    }
  }
}