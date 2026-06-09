import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/ResetPassword/models/ResetPasswordModel.dart';
import 'package:hometasks/src/User/models/UserDBModel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

/// Logger
final Logger _log = Logger('ResetPasswordRepository');

/// Responsável pela conexão com o banco remoto
class ResetPasswordRepository {
  /// Referência à coleção ResetPassword
  final ref = firestore.collection('ResetPassword');

  //-----------------------------
  //            create
  //-----------------------------
  /// Criação de uma nova instância no banco remoto
  Future<Response> createResetPassword(
    ResetPasswordModel forgotPasswordModel,
  ) async {
    _log.info('createResetPassword iniciado | email=${forgotPasswordModel.email}');

    try {
      late final bool val;

      try {
        final pesq = firestore.collection('User');

        await pesq
            .where('email', WhereFilter.equal, forgotPasswordModel.email)
            .get();

        val = true;

        _log.fine('Usuário encontrado para reset password');
      } catch (_) {
        val = false;
        _log.warning('Erro na validação de email');
      }

      if (val) {
        const uuid = Uuid();
        final newId = uuid.v4();

        final random = Random();

        final model = ResetPasswordModel.toModel({
          'email': forgotPasswordModel.email,
          'newPassword': '',
          'code': (100000 + random.nextInt(900000)).toString(),
        });

        _log.info('Código gerado | id=$newId | email=${model.email}');

        // Emissão de email
        final smtpServer = gmail(
          'caiohchagas92@gmail.com',
          'ykkg tbqj mioo ttrm',
        );

        final message = Message()
          ..from = const Address('caiohchagas92@gmail.com', 'HomeTasks')
          ..recipients.add(forgotPasswordModel.email)
          ..subject = 'Código de alteração de senha'
          ..text = 'Olá! Seu código de alteração de senha é ${model.code}.'
          ..html =
              '<h1>Olá!</h1><p>Email enviado pela equipe do Hometasks.</p>';

        await send(message, smtpServer);

        _log.info('Email enviado com sucesso | email=${forgotPasswordModel.email}');

        await ref.doc(newId).set(model.toMap());

        _log.info('ResetPassword salvo no banco | id=$newId');

        return Response.json(
          statusCode: HttpStatus.created,
          body: {
            'code': model.toMap(),
            'id': newId,
          },
        );
      } else {
        _log.warning(
          'createResetPassword falhou | email não encontrado=${forgotPasswordModel.email}',
        );

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Email não registrado no sistema',
        );
      }
    } catch (e, st) {
      _log.severe('Erro em createResetPassword', e, st);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update - JWT
  //-----------------------------
  /// Atualizar uma instância no banco remoto
  Future<Response> updateResetPassword(
    String id,
    RequestContext context,
    ResetPasswordModel resetPassword,
  ) async {
    _log.info('updateResetPassword iniciado | id=$id');

    try {
      if (resetPassword.newPassword != '') {
        await ref.doc(id).update(resetPassword.toMap());

        _log.info('ResetPassword atualizado | id=$id');

        final pesq = firestore.collection('User');

        final user = await pesq
            .where('email', WhereFilter.equal, resetPassword.email)
            .get();

        if (user.docs.isEmpty) {
          _log.warning('Usuário não encontrado para update password');
          return Response.json(
            statusCode: HttpStatus.notFound,
            body: 'Usuário não encontrado',
          );
        }

        final mod = UserDBModel.fromFirestore(user.docs.first);

        final modMap = mod.toMap();
        modMap['password'] = resetPassword.newPassword;

        await pesq.doc(mod.id).update(modMap);

        _log.info('Senha atualizada no User | userId=${mod.id}');

        return Response.json(
          statusCode: HttpStatus.accepted,
          body: 'Senha atualizada com sucesso',
        );
      } else {
        _log.warning('Tentativa de update com senha vazia | id=$id');

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'É necessária uma senha nova, o campo está vazio',
        );
      }
    } catch (e, st) {
      _log.severe('Erro em updateResetPassword', e, st);
      throw Exception(e);
    }
  }
}