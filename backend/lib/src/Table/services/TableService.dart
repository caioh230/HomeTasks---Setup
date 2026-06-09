import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:hometasks/src/Table/repositories/TableRepository.dart';

/// Classe intermediária para as requisições
class TableService {
  static final _log = Logger('TableService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Solicitação de criação
  Future<Response> createTable(
    TableModel table,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'create_table_requested',
      }.toString());

      final repository = context.read<TableRepository>();

      return repository.createTable(table, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_table_failed',
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
  /// Solicitação de leitura
  Future<Response> readTable(
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_table_requested',
        'table_id': id,
      }.toString());

      final repository = context.read<TableRepository>();

      return repository.readTable(id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_table_failed',
          'table_id': id,
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
  Future<Response> updateTable(
    String id,
    TableModel table,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'update_table_requested',
        'table_id': id,
      }.toString());

      final repository = context.read<TableRepository>();

      return repository.updateTable(id, table, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'update_table_failed',
          'table_id': id,
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
  Future<Response> deleteTable(
    String id,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'delete_table_requested',
        'table_id': id,
      }.toString());

      final repository = context.read<TableRepository>();

      return repository.deleteTable(id, context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_table_failed',
          'table_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}