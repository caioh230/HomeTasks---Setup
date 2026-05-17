import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/repositories/TaskRepository.dart';

///Intermediário das requisições
class TaskService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createTask(TaskModel task) async {
    try{
      return TaskRepository().createTask(task);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura individual
  Future<Response> readTask(String id, RequestContext context) async{
    try{
      return TaskRepository().readTask(id);

    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura conjunta
  Future<Response> readColumnTasks(String id, RequestContext context) async{
    try{
      return TaskRepository().readTask(id);

    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateTask(String id, TaskModel task) async{
    try{
      return TaskRepository().updateTask(id, task);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteTask(String id) async{
    try{
      return TaskRepository().deleteTask(id);
    }catch(e){
      throw Exception(e);
    }
  }
}
