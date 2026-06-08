import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/ResetPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/models/ResetPasswordModel.dart';
import 'package:hometasks/src/User/models/UserDBModel.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:uuid/uuid.dart';

///Responsável pela conexão com o banco remoto
class ResetPasswordRepository {
  ///Referência à coleção ResetPassword
  final ref = firestore.collection('ResetPassword');

  //-----------------------------
  //            create
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createResetPassword(
    ForgotPasswordModel forgotPasswordModel
    ) async {
      try {        
        late final bool val;
        try{  
          final pesq = firestore.collection('User');
          
          await pesq.where(
            'email', 
            WhereFilter.equal, 
            forgotPasswordModel.email
          ).get();

          val = true;
        }catch(_){
        }

        if(
          val
        ){
          //Criação de id customizado
          const uuid = Uuid();
          final newId = uuid.v4();

          final random = Random();

          final model = ResetPasswordModel.toModel(
            {
              'email': forgotPasswordModel.email,
              'newPassword': '',
              'code': (100000 + random.nextInt(900000)).toString()
            }
          );

          //Emissão de email
           final smtpServer = gmail(
            'caiohchagas92@gmail.com',
            'ykkg tbqj mioo ttrm',
          );

          final message =
              Message()
                ..from = const Address('caiohchagas92@gmail.com', 'HomeTasks')
                ..recipients.add(forgotPasswordModel.email)
                ..subject = 'Código de alteração de senha'
                ..text = 'Olá! Seu código de alteração de senha é ${model.code}.'
                ..html = '<h1>Olá!</h1><p>Email enviado pela equipe do Hometasks.</p>';

          await send(message, smtpServer);

          //Interação com o banco remoto
          await ref
          .doc(newId)
          .set(
            model.toMap()
          );

          return Response.json(
            statusCode: HttpStatus.created,
            body: {
              'code': model.toMap(),
              'id': newId
            },
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest,
            body: 'Email não registrado no sistema'
          );
        }
      } catch (e) {
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update - JWT
  //-----------------------------
  ///Atualizar uma instância no banco remoto
  Future<Response> updateResetPassword(
    String id,
    RequestContext context,
    ResetPasswordModel resetPassword
    ) async{ 
      try{
        if(
          resetPassword.newPassword != ''
        ){
          await ref
            .doc(id)
            .update(resetPassword.toMap()); 

          final pesq = firestore.collection('User');

          //Atualização de senha do usuário          
          final user = await pesq.where(
            'email', 
            WhereFilter.equal, 
            resetPassword.email
          ).get();

          final mod = UserDBModel.fromFirestore(user.docs.first);
          
          final modMap = mod.toMap();
          modMap['password'] = resetPassword.newPassword; 

          await pesq
          .doc(mod.id)
          .update(modMap);

          return Response.json(
            statusCode: HttpStatus.accepted, 
            body: 'Senha atualizada com sucesso',
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'É necessária uma senha nova, o campo está vazio',
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }
}
