import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipPatchModel.dart';

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
          return updateRelationship(id, context);
        case HttpMethod.delete:
          return deleteRelationship(id, context);
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
      
      return service.readRelationship(
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
Future<Response> updateRelationship(
  String id,
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.updateRelationship(
        id,
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
  String id,
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      return service.deleteRelationship(
        id,
        context
      );
    }catch(e){
      throw Exception(e);
    }
}

//-----------------------------
//            Patch
//-----------------------------
Future<Response> patchRelationship(
  String id,
  RequestContext context
  )async{
    try{
      final service = context.read<RelationshipService>();

      final data = await context.request.json() as Map<String, dynamic>;

      return service.patchRelationship(
        id,
        RelationshipPatchModel.toModel(data), 
        context
      );
    }catch(e){
      throw Exception(e);
    }
}
