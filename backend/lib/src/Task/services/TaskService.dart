import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/repositories/TaskRepository.dart';

///Intermediário das requisições
class TaskService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createTask(
    TaskModel task, 
    RequestContext context
    ) async {
      try{
        final repository = context.read<TaskRepository>();

        return repository.createTask(task, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura individual
  Future<Response> readTask(
    String idTable,
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<TaskRepository>();

        return repository.readTask(idTable, id, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura conjunta
  Future<Response> readTableTasks(
    String idTable,
    RequestContext context
    ) async{
      try{
        final repository = context.read<TaskRepository>();

        return repository.readTableTasks(idTable, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateTask(
    String id, 
    TaskModel task, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<TaskRepository>();

        return repository.updateTask(id, task, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteTask(
    String idTable,
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<TaskRepository>();

        return repository.deleteTask(idTable, id, context);
      }catch(e){
        throw Exception(e);
      }
  }
}
