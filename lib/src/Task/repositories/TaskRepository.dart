import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Task/models/TaskDBModel.dart';
import 'package:hometasks/src/Task/models/TaskModel.dart';

///Repositório de conexão com o banco remoto 
class TaskRepository {
  ///Referência à coleção Task 
  final ref = firestore.collection('Task');

  //-----------------------------
  //            create
  //-----------------------------
  ///Registro de Nova instância
  Future<Response> createTask(TaskModel task) async {
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
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Leitura de tarefa pré-registrada
  Future<Response> readTask(String id) async{
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
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Leitura de tarefas pertencentes à mesma coluna
  Future<Response> readColumnTasks(String id) async{
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
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Atualização de tarefa única
  Future<Response> updateTask(String id, TaskModel task) async{ 
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
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Deleção de tarefa única
  Future<Response> deleteTask(String id) async{
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
  }
}
