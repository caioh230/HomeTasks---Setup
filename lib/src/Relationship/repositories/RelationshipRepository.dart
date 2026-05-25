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
  //            read - JWT
  //-----------------------------
  ///Leitura de relacionamento único
  Future<Response> readRelationship(
    String idUser,
    String idTable
    ) async{
      try{
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          idUser
        )
        .where(
          'idTable', 
          WhereFilter.equal, 
          idTable
        )
        .get();

        final formDados = RelationshipDBModel.fromFirestore(val.docs.first);
        
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

        final formDados = <Map<String, dynamic>>[];
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
    String idUser,
    String idTable,
    RelationshipModel relationship
    ) async{ 
      try{
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          idUser
        )
        .where(
          'idTable', 
          WhereFilter.equal, 
          idTable
        )
        .get();

        await ref
        .doc(RelationshipDBModel.fromFirestore(val.docs.first).id)
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
    String idUser,
    String idTable
    ) async{
      try{
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          idUser
        )
        .where(
          'idTable', 
          WhereFilter.equal, 
          idTable
        )
        .get();

        await ref
        .doc(RelationshipDBModel.fromFirestore(val.docs.first).id)
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
