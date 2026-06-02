import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Notification/models/NotificationModel.dart';
import 'package:hometasks/src/Notification/repositories/NotificationRepository.dart';

///Classe intermediária das requisições
class NotificationService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createNotification(
    NotificationModel notification,
    RequestContext context
    ) async {
      try{
        final repository = context.read<NotificationRepository>();

        return repository.createNotification(notification, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readNotification(
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<NotificationRepository>();

        return repository.readNotification(id, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readAllNotifications(
    RequestContext context
    ) async{
      try{
        final repository = context.read<NotificationRepository>();

        return repository.readAllNotifications(context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteNotification(
    String id,
    RequestContext context
    ) async{
      try{
        final repository = context.read<NotificationRepository>();

        return repository.deleteNotification(id, context);
      }catch(e){
        throw Exception(e);
      }
  }
}
