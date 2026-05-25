import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Column/models/ColumnModel.dart';
import 'package:hometasks/src/Column/services/ColumnService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(
  RequestContext context
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
        case HttpMethod.post:
          return createColumn(context);

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
Future<Response> createColumn(
  RequestContext context
  )async{
    try{
      final service = context.read<ColumnService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createColumn(
        ColumnModel.toModel(data),
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
