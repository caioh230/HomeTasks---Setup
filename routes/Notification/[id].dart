import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Notification/services/NotificationService.dart';

//-----------------------------
//            main
//-----------------------------
Future<dynamic> onRequest(
  RequestContext context, 
  String id
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
          return readNotification(id, context);
        case HttpMethod.put:
        case HttpMethod.delete:
          return deleteNotification(id, context);
        
        case HttpMethod.post:
        case HttpMethod.head:
        case HttpMethod.options:
        case HttpMethod.patch:
      }
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Read
//-----------------------------
Future<dynamic> readNotification(
  String id, 
  RequestContext context
  ) async{
    try{
      final service = context.read<NotificationService>();
      
      return service.readNotification(
        id, 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
Future<Response> deleteNotification(
  String id, 
  RequestContext context
  )async{
    try{
      final service = context.read<NotificationService>();

      return service.deleteNotification(
        id,
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
