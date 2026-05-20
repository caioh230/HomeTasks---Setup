import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/services/RelationshipService.dart';

//-----------------------------
//            main
//-----------------------------
Future<Response> onRequest(RequestContext context) async{
  try{
    switch (context.request.method){
      case HttpMethod.get:
      case HttpMethod.post:
        return createRelationship(context);

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
Future<Response> createRelationship(RequestContext context)async{
  try{
    final service = context.read<RelationshipService>();

    final data = await context.request.json() as Map<String, dynamic>;

    return service.createRelationship(RelationshipModel.toModel(data));
  }catch(e){
    throw Exception(e);
  }
}
