import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Relationship/services/RelationshipService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(
  RequestContext context
  ) async{
    try{
      switch (context.request.method){
        case HttpMethod.get:
          return readPendingRelationships(context);
        case HttpMethod.post:
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
Future<Response> readPendingRelationships(
  RequestContext context
  ) async{
    try{
      final service = context.read<RelationshipService>();
      
      return service.readPendingRelationships(
        context
      );
    } catch (e) {
    return Response.json(
      statusCode: 500,
      body: 'Error: $e',
    );
  }
}
