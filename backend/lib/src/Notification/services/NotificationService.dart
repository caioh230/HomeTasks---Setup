import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/Notification/models/NotificationModel.dart';
import 'package:hometasks/src/Notification/repositories/NotificationRepository.dart';

/// Classe intermediária das requisições
class NotificationService {
  static final _log = Logger('NotificationService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Solicitação de criação
  Future<Response> createNotification(
    NotificationModel notification,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'create_notification_requested',
      }.toString());

      final repository = context.read<NotificationRepository>();

      return repository.createNotification(notification, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_notification_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  /// Solicitação de leitura
  Future<Response> readNotification(
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_notification_requested',
        'notification_id': id,
      }.toString());

      final repository = context.read<NotificationRepository>();

      return repository.readNotification(id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_notification_failed',
          'notification_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  /// Solicitação de leitura de todas as notificações
  Future<Response> readAllNotifications(
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_all_notifications_requested',
      }.toString());

      final repository = context.read<NotificationRepository>();

      return repository.readAllNotifications(context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_all_notifications_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  /// Solicitação de remoção
  Future<Response> deleteNotification(
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'delete_notification_requested',
        'notification_id': id,
      }.toString());

      final repository = context.read<NotificationRepository>();

      return repository.deleteNotification(id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_notification_failed',
          'notification_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}