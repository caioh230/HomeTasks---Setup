import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Column/models/ColumnDBModel.dart';
import 'package:hometasks/src/Column/models/ColumnModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Classe para interação direta com o banco remoto
class ColumnRepository {
  ///Referência à coleção Column
  final ref = firestore.collection('Column');

  //-----------------------------
  //            create - Editor
  //-----------------------------
  ///Operação de criação
  Future<Response> createColumn(
    String idTable,
    ColumnModel column,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, 'Editor', context)){
        try{

          await ref
          .doc()
          .set(column.toMap());
          
          return Response.json(
            statusCode: HttpStatus.created, 
            body: 'Criação bem sucedida'
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não possui acesso à esta operação'
        );
      }
  }

  //-----------------------------
  //            read - Reader
  //-----------------------------
  ///Operação de leitura individual
  Future<Response> readColumn(
    String idTable,
    String id,
    RequestContext context
    ) async {
    if(await _validateOpr(idTable, 'Reader', context)){
      try{
        final val = await ref
        .doc(id)
        .get();

        final formDados = ColumnDBModel.fromFirestore(val);
        
        return Response.json(
          statusCode: HttpStatus.found, 
          body: formDados.toMap()
        );
      }catch(e){
        throw Exception(e);
      }
    }else{
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não possui acesso à esta operação'
      );
    }
  }

  //-----------------------------
  //            read - Reader
  //-----------------------------
  ///Operação de leitura em conjunto
  Future<Response> readAllColumns(
      String idTable,
      RequestContext context
      ) async {
      if(await _validateOpr(idTable, 'Reader', context)){
        try{
          final val = await ref
          .get();
          
          final formDados = <Map<String, dynamic>>[];
          for (var i = 0; i < val.docs.length; i++){
            formDados.add(ColumnDBModel.fromFirestore(val.docs[i]).toMap());
          }

          return Response.json(
            statusCode: HttpStatus.found, 
            body: formDados
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não possui acesso à esta operação'
        );
      }
  }

  //-----------------------------
  //            update - Editor
  //-----------------------------
  ///Operação de atualização individual
  Future<Response> updateColumn(
    String idTable,
    String id, 
    ColumnModel column,
    RequestContext context
    ) async { 
      if(await _validateOpr(idTable, 'Editor', context)){
        try{
          await ref
          .doc(id)
          .update(column.toMap());

          return Response.json(
            statusCode: HttpStatus.accepted, 
            body: 'Atualização bem sucedida'
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não possui acesso à esta operação'
        );
      }
  }

  //-----------------------------
  //            delete - Editor
  //-----------------------------
  ///Operação de remoção individual
  Future<Response> deleteColumn(
    String idTable,
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, 'Editor', context)){
        try{
          await ref
          .doc(id)
          .delete();

          return Response(
            statusCode: HttpStatus.accepted, 
            body: 'Deleção bem sucedida'
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Você não possui acesso à esta operação'
        );
      }
  }
}

//-----------------------------
//      Permissão Cargos + RLS
//-----------------------------
///Limitar as operações a depender do cargo do usuário
Future<bool> _validateOpr(
  String idTable,
  String cargo,
  RequestContext context,
)async{
  try{
    //Obtenção de dados do usuário
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(_env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
    
    //Busca pelo cargo do usuário
    final relationships = firestore.collection('Relationship');

    final data = await relationships
      .where(
        'idUser', 
        WhereFilter.equal, 
        payload['id'].toString()
      )
      .where(
        'idTable', 
        WhereFilter.equal, 
        idTable
      )
      .get();

    if(
      data.docs.first.data().isNotEmpty
      &&
      data.docs.first.data()['cargo'] == cargo
    ){
      return true;
    }else{
      return false;
    }
  }catch(e){
    return false;
  }
}
