import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
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
          return createRelationship(context);
        case HttpMethod.post:
          return createRelationship(context);
        case HttpMethod.put:
          return updateRelationship(context);
        case HttpMethod.delete:
          return createRelationship(context);
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
Future<Response> createRelationship(
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.createRelationship(
        RelationshipModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Update
//-----------------------------
Future<Response> updateRelationship(
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateRelationship(
        data['idUser'].toString(),
        data['idTable'].toString(), 
        RelationshipModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//          Delete
//-----------------------------
Future<Response> deleteRelationship(
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.deleteRelationship(
        data['idUser'].toString(),
        data['idTable'].toString(), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
