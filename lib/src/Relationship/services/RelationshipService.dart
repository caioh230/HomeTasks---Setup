import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/repositories/RelationshipRepository.dart';

///Importação de dados sensíveis
final env = DotEnv()..load();

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

        return repository.createRelationship(relationship);
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

        if(validateid(idUser, context)){        
          return repository.readRelationship(idUser, idTable);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
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

        if(validateid(idUser, context)){        
          return repository.readAllRelationships(idUser);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
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

        if(validateid(idUser, context)){        
          return repository.updateRelationship(idUser,idTable, relationship);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
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

        if(validateid(idUser, context)){        
          return repository.deleteRelationship(idUser, idTable);
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Não é possível alterar os campos de outro usuário'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }
}

//-----------------------------
//            RLS
//-----------------------------
///Garante que o usuário só altere as próprias coleções
bool validateid(
  String id, 
    RequestContext context
  ){
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
  
    if(payload['id'].toString() == id){
      return true;
    }
    else{
      return false;
    }
}
