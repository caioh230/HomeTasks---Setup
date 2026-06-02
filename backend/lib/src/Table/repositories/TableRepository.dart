import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Table/models/TableDBModel.dart';
import 'package:hometasks/src/Table/models/TableModel.dart';

import 'package:uuid/uuid.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Requisições diretas ao banco remoto
class TableRepository {
  ///Referência à coleção 'Table'
  final ref = firestore.collection('Table');

  //-----------------------------
  //            create - JWT
  //-----------------------------
  ///Criação de novo registro no banco remoto
  Future<Response> createTable(
    TableModel table,
    RequestContext context
    ) async {
      try{
        //Criação de id customizado
        const uuid = Uuid();
        final newId = uuid.v4();

        await ref
        .doc(newId)
        .set(table.toMap());

        //Operação cascata
        final relationship = firestore.collection('Relationship');
        
        final idUser = _jwtId(context).toString();

        final map = {
          'idUser': idUser,
          'idTable': newId,
          'roleName': 'Admin',
          'tableName': table.name,
        };

        await relationship
        .doc()
        .set(map);

        return Response.json(
          statusCode: HttpStatus.created, 
          body: 'Criação de quadro bem sucedida'
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - Reader
  //-----------------------------
  ///Leitura individual das mesas
  Future<Response> readTable(
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(id, 'Reader', context)){
        try{
          final val = await ref
          .doc(id)
          .get();

          final formDados = TableDBModel.fromFirestore(val);
          
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
          body: 'Você não possui acesso à este quadro'
        );
      }
  }

  //-----------------------------
  //            update - Admin
  //-----------------------------
  ///Atualização individual da table
  Future<Response> updateTable(
    String id, 
    TableModel table,
    RequestContext context
    ) async { 
      if(await _validateOpr(id, 'Admin', context)){
        try{

          await ref
          .doc(id)
          .update(table.toMap());

          return Response.json(
            statusCode: HttpStatus.accepted, 
            body: 'Atualização de quadro bem sucedida'
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
  //            delete - Admin
  //-----------------------------
  ///Remoção individual das tables
  Future<Response> deleteTable(
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(id,  'Admin', context)){
        try{
          await ref
          .doc(id)
          .delete();

          //Operação cascata
          final relationship = firestore.collection('Relationship');

          final lista = await relationship
          .where(
            'idTable', 
            WhereFilter.equal, 
            id
          )
          .get();

          final formDados = <Map<String, dynamic>>[];

          for (var i = 0; i < lista.docs.length; i++){
            formDados.add(TableDBModel.fromFirestore(lista.docs[i]).toMap());
          }

          for (var i = 0; i < lista.docs.length; i++){
            await relationship
            .doc(formDados[i]['id'].toString())
            .delete();
          }

          return Response(
            statusCode: HttpStatus.accepted, 
            body: 'Deleção de quadro bem sucedida'
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

//-----------------------------
//             ID do usuário
//-----------------------------
///Limitar as operações relacionadas ao usuário
Future<String> _jwtId(
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
    
    return payload['id'].toString();
  }catch(e){
    return '';
  }
}
