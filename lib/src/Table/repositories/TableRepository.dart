import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Table/models/TableDBModel.dart';
import 'package:hometasks/src/Table/models/TableModel.dart';

///Requisições diretas ao banco remoto
class TableRepository {
  ///Referência à coleção 'Table'
  final ref = firestore.collection('Table');

  //-----------------------------
  //            create - Admin
  //-----------------------------
  ///Criação de novo registro no banco remoto
  Future<Response> createTable(TableModel table) async {
    try{
      await ref
      .doc()
      .set(table.toMap());
      
      return Response.json(
        statusCode: HttpStatus.created, 
        body: 'Criação bem sucedida'
      );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read - Reader
  //-----------------------------
  ///Leitura individual das mesas
  Future<Response> readTable(String id) async{
    try{
      final val = await ref
      .doc(id)
      .get();

      final formDados = TableDBModel.fromFirestore(val);
      
      return Response.json(
        statusCode: HttpStatus.found, 
        body: formDados.toMap()
      );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update - Admin
  //-----------------------------
  ///Atualização individual da table
  Future<Response> updateTable(String id, TableModel table) async{ 
    try{

      await ref
      .doc(id)
      .update(table.toMap());

      return Response.json(
        statusCode: HttpStatus.accepted, 
        body: 'Atualização bem sucedida'
      );
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete - Admin
  //-----------------------------
  ///Remoção individual das tables
  Future<Response> deleteTable(String id) async{
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
