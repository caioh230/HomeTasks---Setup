import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Task/models/TaskDBModel.dart';
import 'package:hometasks/src/Task/models/TaskModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Repositório de conexão com o banco remoto 
class TaskRepository {
  ///Referência à coleção Task 
  final ref = firestore.collection('Task');

  //-----------------------------
  //            create - editor
  //-----------------------------
  ///Registro de Nova instância
  Future<Response> createTask(
    TaskModel task,
    RequestContext context
    ) async {
      if(await _validateOpr(task.idTable, 'editor', context)){
        try{
          await ref
          .doc()
          .set(task.toMap());
          
          return Response.json(
            statusCode: HttpStatus.created, 
            body: 'Criação bem sucedida'
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json();
      }
  }

  //-----------------------------
  //            read - reader
  //-----------------------------
  ///Leitura de tarefa pré-registrada
  Future<Response> readTask(
    String idTable,
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, 'reader', context)){
        try{
          final val = await ref
          .doc(id)
          .get();

          final formDados = TaskDBModel.fromFirestore(val);
          
          return Response.json(
            statusCode: HttpStatus.found, 
            body: formDados.toMap()
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json();
      }
  }

  //-----------------------------
  //            read - reader
  //-----------------------------
  ///Leitura de tarefas pertencentes à mesma coluna
  Future<Response> readColumnTasks(
    String idTable,
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, 'reader', context)){
        try{
          final val = ref
          .where(
              'idColumns', 
              WhereFilter.equal, 
              id
            )
          .get();
          
          return Response.json(
            statusCode: HttpStatus.found, 
            body: val
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json();
      }
  }

  //-----------------------------
  //            update - editor
  //-----------------------------
  ///Atualização de tarefa única
  Future<Response> updateTask(
    String id, 
    TaskModel task,
    RequestContext context
    ) async {
      if(await _validateOpr(task.idTable, 'editor', context)){
        try{

          await ref
          .doc(id)
          .update(task.toMap());

          return Response.json(
            statusCode: HttpStatus.accepted, 
            body: 'Atualização bem sucedida'
          );
        }catch(e){
          throw Exception(e);
        }
      }else{
        return Response.json();
      }
  }

  //-----------------------------
  //            delete - editor
  //-----------------------------
  ///Deleção de tarefa única
  Future<Response> deleteTask(
    String idTable,
    String id,
    RequestContext context
    ) async {
      if(await _validateOpr(idTable, 'editor', context)){
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
        return Response.json();
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
    final list = ['reader', 'editor', 'owner'];
    //Obtenção de dados do usuário
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null) {
      throw Exception('Authorization não informado');
    }

    if (!authHeader.startsWith('Bearer ')) {
      throw Exception('Token inválido');
    }

    final token = authHeader.substring('Bearer '.length);
    final jwt = JWT.verify(
      token,
      SecretKey(_env['jwtSecretKey'].toString()),
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
      list.indexOf(data.docs.first.data()['cargo'].toString()) 
        >=  
        list.indexOf(cargo)
    ){
      return true;
    }else{
      return false;
    }
  }catch(e){
    return false;
  }
}
