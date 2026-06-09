import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/Relationship/models/RelationshipModel.dart';
import 'package:hometasks/src/Relationship/models/RelationshipPatchModel.dart';

import 'package:hometasks/src/Relationship/repositories/RelationshipRepository.dart';

/// Intermediário das requisições
class RelationshipService {
  static final _log = Logger('RelationshipService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Solicitação de criação
  Future<Response> createRelationship(
    RelationshipModel relationship,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'create_relationship_requested',
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.createRelationship(
        relationship,
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_relationship_failed',
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
  Future<Response> readRelationship(
    String idTable,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_relationship_requested',
        'table_id': idTable,
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.readRelationship(
        idTable,
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_relationship_failed',
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
  Future<Response> readAllRelationships(
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_all_relationships_requested',
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.readAllRelationships(
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_all_relationships_failed',
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
  Future<Response> updateRelationship(
    String idTable,
    RelationshipModel relationship,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'update_relationship_requested',
        'table_id': idTable,
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.updateRelationship(
        idTable,
        relationship,
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'update_relationship_failed',
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
  //            delete
  //-----------------------------
  /// Solicitação de remoção
  Future<Response> deleteRelationship(
    String idTable,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'delete_relationship_requested',
        'table_id': idTable,
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.deleteRelationship(
        idTable,
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_relationship_failed',
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
  //            Patch
  //-----------------------------
  /// Solicitação de atualização parcial
  Future<Response> patchRelationship(
    String idTable,
    RelationshipPatchModel relationship,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'patch_relationship_requested',
        'table_id': idTable,
      }.toString());

      final repository = context.read<RelationshipRepository>();

      return repository.patchRelationship(
        idTable,
        relationship,
        context,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'patch_relationship_failed',
          'table_id': idTable,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}