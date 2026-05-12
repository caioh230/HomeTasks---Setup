import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:user/config/DataBase_client.dart';
import 'package:user/src/User/models/UserModel.dart';


class UserRepository {
  final ref = firestore.collection("User");

  //-----------------------------
  //            create
  //-----------------------------
  Future<Response> createUser(UserModel user) async {
    try{
      await ref
        .doc()
        .set(user.toMap());
      
      return Response.json(statusCode: HttpStatus.created, body: 'Criação bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  Future<Response> readUser(String id) async{
    try{
      final val = await ref
        .doc(id)
        .get(); 
      
      return Response.json(statusCode: HttpStatus.found, body: val.data());
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  Future<Response> isUser(UserModel user) async{
    try{
      final val = await ref
        .where(
          'email', 
          WhereFilter.equal, 
          user.email
        ).where(
          'password', 
          WhereFilter.equal, 
          user.password
        )
        .get(); 
      
      if (!val.empty){
        return Response.json(statusCode: HttpStatus.found, body:"Encontrado");
      }else{
        return Response.json(statusCode: HttpStatus.notFound);
      }
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  Future<Response> updateUser(String id, UserModel user) async{ 
    try{

      await ref
        .doc(id.toString())
        .update(user.toMap()); 

      return Response.json(statusCode: HttpStatus.accepted, body: 'Atualização bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  Future<Response> deleteUser(String id) async{
    try{
      await ref
        .doc(id)
        .delete();
      
      return Response(statusCode: HttpStatus.accepted, body: 'Deleção bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }
}