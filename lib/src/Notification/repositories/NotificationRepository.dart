import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Notification/models/NotificationDBModel.dart';
import 'package:hometasks/src/Notification/models/NotificationModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Classe para interação direta com o banco remoto
class NotificationRepository {
  ///Referência à coleção Notification
  final ref = firestore.collection('Notification');

  //-----------------------------
  //            create - JWT
  //-----------------------------
  ///Operação de criação
  Future<Response> createNotification(
    NotificationModel notification,
    RequestContext context
    ) async {
      if(notification.fromUser == _validateUsr(context).toString()){
        try{
          await ref
          .doc()
          .set(notification.toMap());
          
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
          body: 'Você não pode emitir uma notificação por outra conta'
        );
      }
  } 

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Operação de leitura individual
  Future<Response> readNotification(
    String id,
    RequestContext context
      ) async{
      try{
        final val = await ref
        .doc(id)
        .get();

        final dados = val.data()!;
        if(
          dados['fromUser'] == _validateUsr(context)
          ||
          dados['toUser'] == _validateUsr(context)
        ){
          final formDados = NotificationDBModel.fromFirestore(val);
          
          return Response.json(
            statusCode: HttpStatus.found, 
            body: formDados.toMap()
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Você não pode ler notificações de outra conta'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Operação de leitura em conjunto
  Future<Response> readAllNotifications(
      RequestContext context
      ) async{
      try{
        final id = _validateUsr(context);
        
        final val = await ref
        .where(
        'idUser', 
          WhereFilter.equal, 
          id.toString()
        )
        .get();
        
        final formDados = <Map<String, dynamic>>[];
        for (var i = 0; i < val.docs.length; i++){
          formDados.add(NotificationDBModel.fromFirestore(val.docs[i]).toMap());
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
  //            update - JWT
  //-----------------------------
  ///Operação de leitura individual
  Future<Response> updateNotification(
    String id,
    NotificationModel notification,
    RequestContext context
      ) async{
      try{
        if(
          notification.fromUser == _validateUsr(context).toString()
        ){
          await ref
          .doc(id)
          .update(notification.toMap());
          
          return Response.json(
            statusCode: HttpStatus.accepted, 
            body: 'Atualização bem sucedida'
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Você não pode atualizar uma notificação por outra conta'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete - JWT
  //-----------------------------
  ///Operação de remoção individual
  Future<Response> deleteNotification(
    String id,
    RequestContext context
    ) async{
      try{
        final val = await ref
        .doc(id)
        .get();

        final data = val.data();
        if (data!['fromUser'] == _validateUsr(context).toString()){
          await ref
            .doc(id)
            .delete();

          return Response(
            statusCode: HttpStatus.accepted, 
            body: 'Deleção bem sucedida'
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Você não pode deletar uma notificação por outra conta'
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }
}

//-----------------------------
//             RLS
//-----------------------------
///Limitar as operações relacionadas ao usuário
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
