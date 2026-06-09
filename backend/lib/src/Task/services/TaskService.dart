import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/models/TaskPatchModel.dart';
import 'package:hometasks/src/Task/repositories/TaskRepository.dart';

/// Intermediário das requisições
class TaskService {
  static final _log = Logger('TaskService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Solicitação de criação
  Future<Response> createTask(
    TaskModel task,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'create_task_requested',
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.createTask(task, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_task_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  /// Solicitação de leitura individual
  Future<Response> readTask(
    String idTable,
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_task_requested',
        'task_id': id,
        'table_id': idTable,
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.readTask(idTable, id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_task_failed',
          'task_id': id,
          'table_id': idTable,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  /// Solicitação de leitura conjunta
  Future<Response> readTableTasks(
    String idTable,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_table_tasks_requested',
        'table_id': idTable,
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.readTableTasks(idTable, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_table_tasks_failed',
          'table_id': idTable,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  /// Solicitação de atualização
  Future<Response> updateTask(
    String id,
    TaskModel task,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'update_task_requested',
        'task_id': id,
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.updateTask(id, task, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'update_task_failed',
          'task_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  /// Solicitação de remoção
  Future<Response> deleteTask(
    String idTable,
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'delete_task_requested',
        'task_id': id,
        'table_id': idTable,
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.deleteTask(idTable, id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_task_failed',
          'task_id': id,
          'table_id': idTable,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            PatchTask
  //-----------------------------
  /// Solicitação de atualização parcial
  Future<Response> patchTask(
    String id,
    TaskPatchModel task,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'patch_task_requested',
        'task_id': id,
      }.toString());

      final repository = context.read<TaskRepository>();

      return repository.patchTask(id, task, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'patch_task_failed',
          'task_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}