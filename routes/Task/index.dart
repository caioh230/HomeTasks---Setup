import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/services/TaskService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(
  RequestContext context
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
          return readColumnTasks(context);
        case HttpMethod.post:
          return createTask(context);

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
//            Read
//-----------------------------
Future<Response> readColumnTasks(
  RequestContext context
  )async{
    try{
      final service = context.read<TaskService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.readColumnTasks(
        TaskModel.toModel(data).idColumn, 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Create
//-----------------------------
Future<Response> createTask(
  RequestContext context
  )async{
    try{
      final service = context.read<TaskService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createTask(
        TaskModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
