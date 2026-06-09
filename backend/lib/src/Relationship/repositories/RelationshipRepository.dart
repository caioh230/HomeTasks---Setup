import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';

import 'package:hometasks/src/Relationship/models/RelationshipDBModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipPatchModel.dart';

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
      if(await _validateOpr(relationship.idTable, context, 'owner')){
        try{
          //Emisão de notificação
          try{
            final notif = firestore.collection('Notification');

            final invitedBy = await _validateUsr(context);
            if(relationship.idUser != invitedBy) {
              await notif
              .doc()
              .create({
                'notificationType': 'invitedToTable',
                'tableId': 'Convite de participação',
                'toUser': relationship.idUser,
                'fromUser': invitedBy,
                'createdAt': DateTime.now().toIso8601String(),
                'read': false,
              });
            }
          }catch(_){
            throw Exception('Erro ao criar Relationship: Não conseguiu criar notificação');
          }

          //Lógica principal da função
          final relac = relationship.toMap();
          relac['valid'] = false;

          await ref
          .doc()
          .set(relac);
          
          return Response.json(
            statusCode: HttpStatus.created, 
            body: 'Criação de relação temporária bem sucedida'
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
    RequestContext context,
  ) async {
    if (await _validateOpr(idTable, context)) {
      try {
        final userId = await _validateUsr(context);

        final val = await ref
            .where('idUser', WhereFilter.equal, userId)
            .where('idTable', WhereFilter.equal, idTable)
            .get();

        if (val.docs.isEmpty) {
          return Response.json(
            statusCode: HttpStatus.notFound,
            body: 'Relationship não encontrado',
          );
        }

        final formDados =
            RelationshipDBModel.fromFirestore(val.docs.first);

        return Response.json(
          statusCode: HttpStatus.ok,
          body: formDados.toMap(),
        );
      } catch (e) {
        return Response.json(
          statusCode: HttpStatus.internalServerError,
          body: {'error': e.toString()},
        );
      }
    }

    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: 'Você não possui autorização para esta operação',
    );
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
        ).where(
          'valid', 
          WhereFilter.equal, 
          true
        )
        .get();

        final formDados = [];
        for (var i = 0; i < val.docs.length; i++) {
          formDados.add(val.docs[i].data()['idTable'].toString());
        }

        return Response.json(
          statusCode: HttpStatus.ok,
          body: formDados
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Leitura de todos os convites pendentes do usuário
  Future<Response> readPendingRelationships(
    RequestContext context
    ) async {
      try{
        final idUser = await _validateUsr(context);
        
        final val = await ref
        .where(
          'idUser', 
          WhereFilter.equal, 
          idUser
        ).where(
          'valid', 
          WhereFilter.equal, 
          false
        )
        .get();

        final formDados = [];

        for (var i = 0; i < val.docs.length; i++) {
          final data = val.docs[i].data();

          formDados.add({
            'id': val.docs[i].id,
            'idTable': data['idTable'],
            'tableName': data['tableName'],
            'createdAt': data['createdAt'],
          });
        }

        return Response.json(
          statusCode: HttpStatus.ok,
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

          if(await _validateOpr(idTable, context, 'owner')){ 
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

  //-----------------------------
  //            Patch - owner
  //-----------------------------
  ///Atualização de relacionamento único - Convidados
  Future<Response> patchRelationship(
    String idTable,
    RelationshipPatchModel relationship,
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
            body: 'Patch bem sucedida'
          );
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
  RequestContext context, [
  String? minimalRole,
]) async {
  try {
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null) {
      throw Exception('Authorization não informado');
    }

    if (!authHeader.startsWith('Bearer ')) {
      throw Exception('Token inválido');
    }

    final token = authHeader.substring('Bearer '.length);

    final jwt = JWT.verify(
      token,
      SecretKey(_env['jwtSecretKey'].toString()),
    );

    final payload = jwt.payload as Map<String, dynamic>;

    final relationships = firestore.collection('Relationship');

    final data = await relationships
        .where('idUser', WhereFilter.equal, payload['id'].toString())
        .where('idTable', WhereFilter.equal, idTable)
        .get();

    if (data.docs.isEmpty) {
      return false;
    }

    const validRoles = ['reader', 'editor', 'owner'];
    final userRole = data.docs.first.data()['roleName']?.toString();
    if(!validRoles.contains(userRole)) {
      //Role invalido
      return false;
    }

    if (minimalRole == null) {
      return true;
    }
    return validRoles.indexOf(userRole!) >= validRoles.indexOf(minimalRole);
  } catch (_) {
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
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null) {
      throw Exception('Authorization não informado');
    }

    if (!authHeader.startsWith('Bearer ')) {
      throw Exception('Token inválido');
    }

    final token = authHeader.substring('Bearer '.length);

    final jwt = JWT.verify(
      token,
      SecretKey(_env['jwtSecretKey'].toString()),
    );

    final payload = jwt.payload as Map<String, dynamic>;
    
    return payload['id'].toString();
  }catch(e){
    throw Exception(e);
  }
}