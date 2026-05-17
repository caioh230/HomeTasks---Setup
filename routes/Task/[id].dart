import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/services/TaskService.dart';

//-----------------------------
//            main
//-----------------------------
Future<dynamic> onRequest(RequestContext context, String id) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
        return readTask(id, context);
      case HttpMethod.put:
        return updateTask(id, context);
      case HttpMethod.delete:
        return deleteTask(id, context);
      
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
Future<dynamic> readTask(String id, RequestContext context) async{
    try{
      final service = context.read<TaskService>();
      
      return service.readTask(id, context);
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Update
//-----------------------------
Future<Response> updateTask(String id, RequestContext context)async{
    try{
      final service = context.read<TaskService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateTask(id, TaskModel.toModel(data));
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
Future<Response> deleteTask(String id, RequestContext context)async{
    try{
      final service = context.read<TaskService>();

      return service.deleteTask(id);
    }catch(e){
      throw Exception(e);
    }
}
