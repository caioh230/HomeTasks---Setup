import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:hometasks/src/Table/services/TableService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(RequestContext context) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
      case HttpMethod.post:
        return createTable(context);

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
Future<Response> createTable(RequestContext context)async{
  try{
    final service = context.read<TableService>();

    final data = await context.request.json() as Map<String, dynamic>;

    return service.createTable(TableModel.toModel(data));
  }catch(e){
    throw Exception(e);
  }
}
