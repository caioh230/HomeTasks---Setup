import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/config/DataBase_client.dart';

import 'package:hometasks/src/Task/models/TaskDBModel.dart';
import 'package:hometasks/src/Task/models/TaskModel.dart';
import 'package:hometasks/src/Task/models/TaskPatchModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Repositório de conexão com o banco remoto
class TaskRepository {
  static final _log = Logger('TaskRepository');

  ///Referência à coleção Task
  final ref = firestore.collection('Task');

  //-----------------------------
  //            create - editor
  //-----------------------------
  ///Registro de Nova instância
  Future<Response> createTask(
    TaskModel task,
    RequestContext context,
  ) async {
    if (await _validateOpr(task.idTable, context, 'editor')) {
      try {
        _log.info({
          'event': 'task_create_started',
          'table_id': task.idTable,
        }.toString());

        await ref.doc().set(task.toMap());

        _log.info({
          'event': 'task_create_success',
          'table_id': task.idTable,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.created,
          body: 'Criação bem sucedida',
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'task_create_failed',
            'table_id': task.idTable,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'task_create_unauthorized',
        'table_id': task.idTable,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não possui autorização para esta operação',
      );
    }
  }

  //-----------------------------
  //            read - reader
  //-----------------------------
  ///Leitura de tarefa pré-registrada
  Future<Response> readTask(
    String idTable,
    String id,
    RequestContext context,
  ) async {
    if (await _validateOpr(idTable, context, 'reader')) {
      try {
        _log.info({
          'event': 'task_read_started',
          'table_id': idTable,
          'task_id': id,
        }.toString());

        final val = await ref.doc(id).get();

        final formDados = TaskDBModel.fromFirestore(val);

        _log.info({
          'event': 'task_read_success',
          'table_id': idTable,
          'task_id': id,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.ok,
          body: formDados.toMap(),
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'task_read_failed',
            'table_id': idTable,
            'task_id': id,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'task_read_unauthorized',
        'table_id': idTable,
        'task_id': id,
      }.toString());

      return Response.json();
    }
  }

  //-----------------------------
  //            read - reader
  //-----------------------------
  ///Leitura de tarefas pertencentes à mesma coluna
  Future<Response> readTableTasks(
    String idTable,
    RequestContext context,
  ) async {
    if (await _validateOpr(idTable, context, 'reader')) {
      try {
        _log.info({
          'event': 'table_tasks_read_started',
          'table_id': idTable,
        }.toString());

        final snapshot = await ref
            .where(
              'idTable',
              WhereFilter.equal,
              idTable,
            )
            .get();

        final tasks = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();

        _log.info({
          'event': 'table_tasks_read_success',
          'table_id': idTable,
          'count': tasks.length,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.ok,
          body: tasks,
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'table_tasks_read_failed',
            'table_id': idTable,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'table_tasks_read_unauthorized',
        'table_id': idTable,
      }.toString());

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
    RequestContext context,
  ) async {
    if (await _validateOpr(task.idTable, context, 'editor')) {
      try {
        _log.info({
          'event': 'task_update_started',
          'task_id': id,
          'table_id': task.idTable,
        }.toString());

        await ref.doc(id).update(task.toMap());

        _log.info({
          'event': 'task_update_success',
          'task_id': id,
          'table_id': task.idTable,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.accepted,
          body: 'Atualização bem sucedida',
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'task_update_failed',
            'task_id': id,
            'table_id': task.idTable,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'task_update_unauthorized',
        'task_id': id,
        'table_id': task.idTable,
      }.toString());

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
    RequestContext context,
  ) async {
    if (await _validateOpr(idTable, context, 'editor')) {
      try {
        _log.info({
          'event': 'task_delete_started',
          'task_id': id,
          'table_id': idTable,
        }.toString());

        await ref.doc(id).delete();

        _log.info({
          'event': 'task_delete_success',
          'task_id': id,
          'table_id': idTable,
        }.toString());

        return Response(
          statusCode: HttpStatus.accepted,
          body: 'Deleção bem sucedida',
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'task_delete_failed',
            'task_id': id,
            'table_id': idTable,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'task_delete_unauthorized',
        'task_id': id,
        'table_id': idTable,
      }.toString());

      return Response.json();
    }
  }

  //-----------------------------
  //            PatchTask - editor
  //-----------------------------
  ///Atualização de tarefa única
  Future<Response> patchTask(
    String id,
    TaskPatchModel task,
    RequestContext context,
  ) async {
    if (await _validateOpr(task.idTable, context, 'editor')) {
      try {
        _log.info({
          'event': 'task_patch_started',
          'task_id': id,
          'table_id': task.idTable,
        }.toString());

        await ref.doc(id).update(task.toMap());

        _log.info({
          'event': 'task_patch_success',
          'task_id': id,
          'table_id': task.idTable,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.accepted,
          body: 'Atualização bem sucedida',
        );
      } catch (e, stackTrace) {
        _log.severe(
          {
            'event': 'task_patch_failed',
            'task_id': id,
            'table_id': task.idTable,
            'error': e.toString(),
          }.toString(),
          e,
          stackTrace,
        );

        throw Exception(e);
      }
    } else {
      _log.warning({
        'event': 'task_patch_unauthorized',
        'task_id': id,
        'table_id': task.idTable,
      }.toString());

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
  RequestContext context, [
  String? minimalRole,
]) async {
  try {
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

    final relationships = firestore.collection('Relationship');

    final data = await relationships
        .where('idUser', WhereFilter.equal, payload['id'].toString())
        .where('idTable', WhereFilter.equal, idTable)
        .get();

    if (data.docs.isEmpty) {
      return false;
    }

    const validRoles = ['reader', 'editor', 'owner'];
    final userRole = data.docs.first.data()['roleName']?.toString();

    if (!validRoles.contains(userRole)) {
      return false;
    }

    if (minimalRole == null) {
      return true;
    }

    return validRoles.indexOf(userRole!) >=
        validRoles.indexOf(minimalRole);
  } catch (_) {
    return false;
  }
}