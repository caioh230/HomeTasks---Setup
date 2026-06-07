import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Relationship/models/RelationshipDBModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Repositório de conexão com o banco remoto 
class RelationshipRepository {
  ///Referência à coleção Relationship 
  final ref = firestore.collection('Relationship');

  //-----------------------------
  //            create - JWT
  //-----------------------------
  ///Registro de Nova instância
  Future<Response> createRelationship(
    RelationshipModel relationship,
    RequestContext context
    ) async {
      if(await _validateOpr(relationship.idTable, context)){
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
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest, 
          body: 'Você não possui autorização para esta operação'
        );
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Leitura de relacionamento único
  Future<Response> readRelationship(
    String idTable,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, context)){
        try{
          final val = await ref
          .where(
            'idUser', 
            WhereFilter.equal, 
            _validateUsr(context)
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
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest, 
          body: 'Você não possui autorização para esta operação'
        );
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Leitura de todos os relacionamentos do usuário
  Future<Response> readAllRelationships(
    RequestContext context
    ) async {
      try{
        final idUser = await _validateUsr(context);
        
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          idUser
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
  //            update - owner
  //-----------------------------
  ///Atualização de relacionamento único - Convidados
  Future<Response> updateRelationship(
    String idTable,
    RelationshipModel relationship,
    RequestContext context
    ) async {
        try{
          final idUser = await _validateUsr(context);

          if(await _validateOpr(idTable, context)){ 
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
          }else{
            return Response.json(
              statusCode: HttpStatus.badRequest, 
              body: 'Você não possui autorização para esta operação'
            );
          }
        }catch(e){
          throw Exception(e);
        }
  }

  //-----------------------------
  //            delete - JWT ou owner
  //-----------------------------
  ///Deleção de relacionamento único
  Future<Response> deleteRelationship(
    String idTable,
    RequestContext context
    ) async {
        try{
          final idUser = await _validateUsr(context);

          if(
            await _validateOpr(idTable, context)
          ){
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
          }else{
            return Response(
              statusCode: HttpStatus.badRequest, 
              body: 'Você não pode executar esta operação, '  
              'esta conta não está em um quadro seu.'
            );
          }
        }catch(e){
          throw Exception(e);
        }
    }
}

//-----------------------------
//          RLS
//-----------------------------
///Limitar as operações relacionadas ao usuário
Future<bool> _validateOpr(
  String idTable,
  RequestContext context,
)async{
  try{
    //Obtenção de dados do usuário
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(_env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
    
    //Busca pelo cargo do usuário
    final relationships = firestore.collection('Relationship');

    final data = await relationships
      .where(
        'idUser', 
        WhereFilter.equal, 
        payload['id'].toString()
      )
      .where(
        'idTable', 
        WhereFilter.equal, 
        idTable
      )
      .get();

    final dados = data.docs.first.data();
    if(
      dados.isNotEmpty
      &&
      dados['roleName'] == 'owner'
    ){
      return true;
    }else{
      return false;
    }
  }catch(e){
    return false;
  }
}

//-----------------------------
//             RLS
//-----------------------------
///Buscar o id do usuário
Future<String> _validateUsr(
  RequestContext context,
)async{
  try{
    //Obtenção de dados do usuário
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(_env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
    
    return payload['id'].toString();
  }catch(e){
    return '';
  }
}
