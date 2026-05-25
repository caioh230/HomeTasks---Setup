import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Relationship/services/RelationshipService.dart';

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
          return readRelationship(id, context);
        case HttpMethod.put:

        case HttpMethod.delete:
        
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
Future<dynamic> readRelationship(
  String id, 
  RequestContext context
  ) async{
    try{
      final service = context.read<RelationshipService>();
      
      return service.readAllRelationships(
        id, 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
