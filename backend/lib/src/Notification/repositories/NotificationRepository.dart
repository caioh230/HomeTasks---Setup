import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Notification/models/NotificationDBModel.dart';
import 'package:hometasks/src/Notification/models/NotificationModel.dart';
import 'package:logging/logging.dart';

/// Importação de dados sensíveis
final _env = DotEnv()..load();

/// Logger da camada de NotificationRepository
final Logger _log = Logger('NotificationRepository');

/// Classe para interação direta com o banco remoto
class NotificationRepository {
  /// Referência à coleção Notification
  final ref = firestore.collection('Notification');

  //-----------------------------
  //            create - JWT
  //-----------------------------
  /// Operação de criação
  Future<Response> createNotification(
    NotificationModel notification,
    RequestContext context,
  ) async {
    final userId = await _validateUsr(context);

    _log.info('createNotification iniciado | fromUser=$userId');

    if (notification.fromUser == userId) {
      try {
        await ref.doc().set(notification.toMap());

        _log.info(
          'createNotification sucesso | toUser=${notification.toUser}',
        );

        return Response.json(
          statusCode: HttpStatus.created,
          body: 'Criação bem sucedida',
        );
      } catch (e, st) {
        _log.severe('Erro em createNotification', e, st);
        throw Exception(e);
      }
    } else {
      _log.warning(
        'createNotification bloqueado | tentativa inválida fromUser=${notification.fromUser}',
      );

      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não pode emitir uma notificação por outra conta',
      );
    }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  /// Operação de leitura individual
  Future<Response> readNotification(
    String id,
    RequestContext context,
  ) async {
    final userId = await _validateUsr(context);

    _log.info('readNotification iniciado | id=$id | userId=$userId');

    try {
      final val = await ref.doc(id).get();

      final dados = val.data();
      if (dados == null) {
        _log.warning('readNotification not found | id=$id');
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'Notificação não encontrada',
        );
      }

      if (dados['fromUser'] == userId || dados['toUser'] == userId) {
        final formDados = NotificationDBModel.fromFirestore(val);

        _log.info('readNotification autorizado | id=$id');

        return Response.json(
          statusCode: HttpStatus.found,
          body: formDados.toMap(),
        );
      } else {
        _log.warning(
          'readNotification negado | userId=$userId | id=$id',
        );

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não pode ler notificações de outra conta',
        );
      }
    } catch (e, st) {
      _log.severe('Erro em readNotification', e, st);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  /// Operação de leitura em conjunto
  Future<Response> readAllNotifications(
    RequestContext context,
  ) async {
    final id = await _validateUsr(context);

    _log.info('readAllNotifications iniciado | userId=$id');

    try {
      final val = await ref
          .where('idUser', WhereFilter.equal, id.toString())
          .get();

      final formDados = <Map<String, dynamic>>[];

      for (var i = 0; i < val.docs.length; i++) {
        formDados.add(NotificationDBModel.fromFirestore(val.docs[i]).toMap());
      }

      _log.info(
        'readAllNotifications concluído | total=${formDados.length}',
      );

      return Response.json(
        statusCode: HttpStatus.found,
        body: formDados,
      );
    } catch (e, st) {
      _log.severe('Erro em readAllNotifications', e, st);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update - JWT
  //-----------------------------
  /// Operação de atualização
  Future<Response> updateNotification(
    String id,
    NotificationModel notification,
    RequestContext context,
  ) async {
    final userId = await _validateUsr(context);

    _log.info('updateNotification iniciado | id=$id | userId=$userId');

    try {
      if (notification.fromUser == userId) {
        await ref.doc(id).update(notification.toMap());

        _log.info('updateNotification sucesso | id=$id');

        return Response.json(
          statusCode: HttpStatus.accepted,
          body: 'Atualização bem sucedida',
        );
      } else {
        _log.warning(
          'updateNotification negado | userId=$userId | id=$id',
        );

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não pode atualizar uma notificação por outra conta',
        );
      }
    } catch (e, st) {
      _log.severe('Erro em updateNotification', e, st);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete - JWT
  //-----------------------------
  /// Operação de remoção individual
  Future<Response> deleteNotification(
    String id,
    RequestContext context,
  ) async {
    final userId = await _validateUsr(context);

    _log.info('deleteNotification iniciado | id=$id | userId=$userId');

    try {
      final val = await ref.doc(id).get();
      final data = val.data();

      if (data == null) {
        _log.warning('deleteNotification not found | id=$id');
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'Notificação não encontrada',
        );
      }

      if (data['fromUser'] == userId) {
        await ref.doc(id).delete();

        _log.info('deleteNotification sucesso | id=$id');

        return Response(
          statusCode: HttpStatus.accepted,
          body: 'Deleção bem sucedida',
        );
      } else {
        _log.warning(
          'deleteNotification negado | userId=$userId | id=$id',
        );

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não pode deletar uma notificação por outra conta',
        );
      }
    } catch (e, st) {
      _log.severe('Erro em deleteNotification', e, st);
      throw Exception(e);
    }
  }
}

//-----------------------------
//             RLS
//-----------------------------
/// Buscar o id do usuário
Future<String> _validateUsr(RequestContext context) async {
  try {
    final request = context.request;
    final header = request.headers['authorization'];

    if (header == null) {
      _log.warning('_validateUsr sem header authorization');
      return '';
    }

    final jwt = JWT.verify(
      header,
      SecretKey(_env['jwtSecretKey'].toString()),
    );

    final payload = jwt.payload as Map<String, dynamic>;

    final id = payload['id'].toString();

    _log.fine('_validateUsr sucesso | userId=$id');

    return id;
  } catch (e) {
    _log.severe('_validateUsr erro', e);
    return '';
  }
}