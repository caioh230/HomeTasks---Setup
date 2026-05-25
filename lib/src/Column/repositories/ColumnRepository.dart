import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Column/models/ColumnDBModel.dart';
import 'package:hometasks/src/Column/models/ColumnModel.dart';


///Classe para interação direta com o banco remoto
class ColumnRepository {
  ///Referência à coleção Column
  final ref = firestore.collection('Column');

  //-----------------------------
  //            create - Editor
  //-----------------------------
  ///Operação de criação
  Future<Response> createColumn(
    ColumnModel column
    ) async {
      try{

        await ref
        .doc()
        .set(column.toMap());
        
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
  ///Operação de leitura individual
  Future<Response> readColumn(
    String id
      ) async{
      try{
        final val = await ref
        .doc(id)
        .get();

        final formDados = ColumnDBModel.fromFirestore(val);
        
        return Response.json(
          statusCode: HttpStatus.found, 
          body: formDados.toMap()
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update - Editor
  //-----------------------------
  ///Operação de atualização individual
  Future<Response> updateColumn(
    String id, 
    ColumnModel column
    ) async{ 
      try{
        await ref
        .doc(id)
        .update(column.toMap());

        return Response.json(
          statusCode: HttpStatus.accepted, 
          body: 'Atualização bem sucedida'
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete - Editor
  //-----------------------------
  ///Operação de remoção individual
  Future<Response> deleteColumn(
    String id
    ) async{
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
