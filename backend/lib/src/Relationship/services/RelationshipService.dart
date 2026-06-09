import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipPatchModel.dart';

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
    String idTable,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();  
        
        return repository.readRelationship(
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
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();
        
        return repository.readAllRelationships(
          context
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
    String idTable, 
    RelationshipModel relationship,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.updateRelationship(
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
    String idTable,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.deleteRelationship( 
          idTable, 
          context
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            Patch
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> patchRelationship(
    String idTable, 
    RelationshipPatchModel relationship,
    RequestContext context
    ) async{
      try{
        final repository = context.read<RelationshipRepository>();

        return repository.patchRelationship(
          idTable, 
          relationship, 
          context
        );
      }catch(e){
        throw Exception(e);
      }
  }
}
