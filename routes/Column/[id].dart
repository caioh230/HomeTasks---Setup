import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Column/models/ColumnModel.dart';
import 'package:hometasks/src/Column/services/ColumnService.dart';

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
          return readColumn(id, context);
        case HttpMethod.put:
          return updateColumn(id, context);
        case HttpMethod.delete:
          return deleteColumn(id, context);
        
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
Future<dynamic> readColumn(
  String id, 
  RequestContext context
  ) async{
    try{
      final service = context.read<ColumnService>();
      
      return service.readColumn(
        id, 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Update
//-----------------------------
Future<Response> updateColumn(
  String id, 
  RequestContext context
  )async{
    try{
      final service = context.read<ColumnService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateColumn(
        id, 
        ColumnModel.toModel(data),
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
Future<Response> deleteColumn(
  String id, 
  RequestContext context
  )async{
    try{
      final service = context.read<ColumnService>();

      return service.deleteColumn(
        id,
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
