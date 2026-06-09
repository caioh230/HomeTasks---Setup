import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/src/ResetPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/models/ResetPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/repositories/ResetPasswordRepository.dart';

/// Serviço responsável como intermediário entre as requisições e o repository
class ResetPasswordService {
  static final _log = Logger('ResetPasswordService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Requisição de criação de nova instância
  Future<Response> createResetPassword(
    ForgotPasswordModel forgotPassword,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'forgot_password_requested',
      }.toString());

      final repository = context.read<ResetPasswordRepository>();

      return repository.createResetPassword(forgotPassword);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'forgot_password_failed',
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
  Future<Response> updateResetPassword(
    String id,
    ResetPasswordModel resetPassword,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'reset_password_requested',
        'reset_id': id,
      }.toString());

      final repository = context.read<ResetPasswordRepository>();

      return repository.updateResetPassword(
        id,
        context,
        resetPassword,
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'reset_password_failed',
          'reset_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}