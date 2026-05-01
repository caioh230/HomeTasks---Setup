import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:user/config/DataBase_client.dart';
import 'package:user/src/User/models/UserDBModel.dart';
import 'package:user/src/User/models/UserModel.dart';


class UserRepository {
  //-----------------------------
  //            create
  //-----------------------------
  Future<Response> createUser(UserModel user) async {
    try{

      await supabase.from('User').insert(user.toMap());
      
      return Response.json(statusCode: HttpStatus.created, body: 'Criação bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  Future<Response> readUser(int id) async{
    try{
      final val = await supabase.from('User')
        .select()
        .eq('id', id);
      
      return Response.json(statusCode: HttpStatus.found, body: val[0]);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  Future<Response> isUser(UserModel user) async{
    try{
      final map = user.toMap();

      final val = await supabase.from('User')
        .select()
        .eq('email', map['email'].toString())
        .eq('password', map['password'].toString());
      
      if (val.isNotEmpty){
        return Response.json(statusCode: HttpStatus.found, body: val);
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
  Future<Response> updateUser(int id, UserModel user) async{ 
    try{

      await supabase.from('User')
      .update(user.toMap())
      .eq('id', id);

      return Response.json(statusCode: HttpStatus.accepted, body: 'Criação bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  Future<Response> deleteUser(int id) async{
    try{
      await supabase.from('User')
      .delete()
      .eq('id', id);
      return Response(statusCode: HttpStatus.accepted, body: 'Deleção bem sucedida');
    }catch(e){
      throw Exception(e);
    }
  }
}