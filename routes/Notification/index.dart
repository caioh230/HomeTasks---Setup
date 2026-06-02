import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Notification/models/NotificationModel.dart';
import 'package:hometasks/src/Notification/services/NotificationService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(
  RequestContext context
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
          return readAllNotifications(context);

        case HttpMethod.post:
          return createNotification(context);

        case HttpMethod.put:
        case HttpMethod.delete:
        case HttpMethod.head:
        case HttpMethod.options:
        case HttpMethod.patch:

        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Create
//-----------------------------
Future<Response> createNotification(
  RequestContext context
  )async{
    try{
      final service = context.read<NotificationService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createNotification(
        NotificationModel.toModel(data),
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Read
//-----------------------------
Future<Response> readAllNotifications(
  RequestContext context
  )async{
    try{
      final service = context.read<NotificationService>();

      return service.readAllNotifications(
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
