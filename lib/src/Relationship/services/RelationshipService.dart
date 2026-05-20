import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/repositories/RelationshipRepository.dart';

///Intermediário das requisições
class RelationshipService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createRelationship(
    RelationshipModel relationship
    ) async {
      try{
        return RelationshipRepository().createRelationship(relationship);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura individual
  Future<Response> readRelationship(
    String id, 
    RequestContext context
    ) async{
      try{
        return RelationshipRepository().readRelationship(id);

      }catch(e){
        throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura conjunta
  Future<Response> readAllRelationships(
    String id, 
    RequestContext context
    ) async{
      try{
        return RelationshipRepository().readAllRelationships(id);

      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateRelationship(
    String id, 
    RelationshipModel relationship
    ) async{
      try{
        return RelationshipRepository().updateRelationship(id, relationship);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteRelationship(
    String id
    ) async{
      try{
        return RelationshipRepository().deleteRelationship(id);
      }catch(e){
        throw Exception(e);
      }
  }
}
