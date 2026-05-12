import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:user/config/DataBase_client.dart';
import 'package:user/src/User/models/UserModel.dart';

///Responsável pela conexão com o banco remoto
class UserRepository {
  ///Referência à coleção User
  final ref = firestore.collection('User');

  //-----------------------------
  //            create
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createUser(UserModel user) async {
    try{
      await ref
        .doc()
        .set(user.toMap());
      
      return Response.json(
        statusCode: HttpStatus.created, 
        body: 'Criação bem sucedida'
      );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Obter instância já registrada no banco remoto
  Future<Response> readUser(String id) async{
    try{
      final val = await ref
        .doc(id)
        .get(); 
      
      return Response.json(
        statusCode: HttpStatus.found, 
        body: val.data()
        );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Verificar se uma instância existe no banco remoto
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
        return Response.json(
          statusCode: HttpStatus.found, 
          body:'Encontrado'
        );
      }else{
        return Response.json(
          statusCode: HttpStatus.notFound
        );
      }
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Atualizar uma instância no banco remoto
  Future<Response> updateUser(String id, UserModel user) async{ 
    try{

      await ref
        .doc(id)
        .update(user.toMap()); 

      return Response.json(
        statusCode: HttpStatus.accepted, 
        body: 'Atualização bem sucedida'
      );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Remoção de instância no banco remoto
  Future<Response> deleteUser(String id) async{
    try{
      await ref
        .doc(id)
        .delete();
      
      return Response(
        statusCode: HttpStatus.accepted, 
        body: 'Deleção bem sucedida'
      );
    }catch(e){
      throw Exception(e);
    }
  }
}
