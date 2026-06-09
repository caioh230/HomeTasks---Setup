import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/User/models/UserGetModel.dart';
import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/repositories/UserRepository.dart';

/// Serviço responsável como intermediário entre as requisições e o repository
class UserService {
  static final _log = Logger('UserService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Requisição de criação de nova instância
  Future<Response> createUser(
    UserModel user,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'create_user_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.createUser(user);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_user_failed',
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
  /// Requisição de leitura de instância
  Future<Response> readUser(
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_user_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.readUser(context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_user_failed',
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
  /// Requisição de leitura de que não seja o usuário
  Future<Response> getUserbyUsername(
    UserGetModel data,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'read_user_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.getUserbyUsername(
        data 
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_user_failed',
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
  /// Requisição de verificação de instância
  Future<Response> isUser(
    UserModel user,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'login_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.isUser(user);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'login_failed',
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
  /// Requisição de verificação de instância por token
  Future<Response> isUserByToken(
    String token,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'token_validation_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.isUserByToken(token);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'token_validation_failed',
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
  /// Requisição de atualização de instância
  Future<Response> updateUser(
    UserModel user,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'update_user_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.updateUser(context, user);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'update_user_failed',
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
  /// Requisição de remoção de instância
  Future<Response> deleteUser(
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'delete_user_requested',
      }.toString());

      final repository = context.read<UserRepository>();

      return repository.deleteUser(context);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_user_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}
