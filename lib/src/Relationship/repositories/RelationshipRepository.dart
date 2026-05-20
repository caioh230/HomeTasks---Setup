import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Relationship/models/RelationshipDBModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';

///Repositório de conexão com o banco remoto 
class RelationshipRepository {
  ///Referência à coleção Relationship 
  final ref = firestore.collection('Relationship');

  //-----------------------------
  //            create - Editor
  //-----------------------------
  ///Registro de Nova instância
  Future<Response> createRelationship(
    RelationshipModel relationship
    ) async {
      try{
        await ref
        .doc()
        .set(relationship.toMap());
        
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
  ///Leitura de relacionamento único
  Future<Response> readRelationship(
    String id
    ) async{
      try{
        final val = await ref
        .doc(id)
        .get();

        final formDados = RelationshipDBModel.fromFirestore(val);
        
        return Response.json(
          statusCode: HttpStatus.found, 
          body: formDados.toMap()
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Leitura de todos os relacionamentos do usuário
  Future<Response> readAllRelationships(
    String id
    ) async{
      try{
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          id
        )
        .get();

        final formDados = []; 
        for (var i = 0; i < val.docs.length; i++){
          formDados.add(RelationshipDBModel.fromFirestore(val.docs[i]).toMap());
        }
        return Response.json(
          statusCode: HttpStatus.found, 
          body: formDados
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update - Editor
  //-----------------------------
  ///Atualização de relacionamento único
  Future<Response> updateRelationship(
    String id, 
    RelationshipModel relationship
    ) async{ 
      try{

        await ref
        .doc(id)
        .update(relationship.toMap());

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
  ///Deleção de relacionamento única
  Future<Response> deleteRelationship(
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
