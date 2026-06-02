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
    RelationshipModel relationship,
    RequestContext context
    ) async {
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.createRelationship(
          relationship,
          context
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura individual
  Future<Response> readRelationship(
    String idUser,
    String idTable,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();  
        
        return repository.readRelationship(
          idUser, 
          idTable,
          context
        );
      }catch(e){
        throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura conjunta
  Future<Response> readAllRelationships(
    String idUser, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();
        
        return repository.readAllRelationships(
          idUser
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateRelationship(
    String idUser,
    String idTable, 
    RelationshipModel relationship,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.updateRelationship(
          idUser,
          idTable, 
          relationship, 
          context
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteRelationship(
    String idUser,
    String idTable,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.deleteRelationship(
          idUser, 
          idTable, 
          context
        );
      }catch(e){
        throw Exception(e);
      }
  }
}
