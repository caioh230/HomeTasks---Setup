import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:hometasks/src/Table/services/TableService.dart';

//-----------------------------
//            main
//-----------------------------
Future<dynamic> onRequest(RequestContext context, String id) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
        return readTable(id, context);
      case HttpMethod.put:
        return updateTable(id, context);
      case HttpMethod.delete:
        return deleteTable(id, context);
      
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
Future<dynamic> readTable(String id, RequestContext context) async{
    try{
      final service = context.read<TableService>();
      
      return service.readTable(id, context);
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Update
//-----------------------------
Future<Response> updateTable(String id, RequestContext context)async{
    try{
      final service = context.read<TableService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateTable(id, TableModel.toModel(data));
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
Future<Response> deleteTable(String id, RequestContext context)async{
    try{
      final service = context.read<TableService>();

      return service.deleteTable(id);
    }catch(e){
      throw Exception(e);
    }
}
