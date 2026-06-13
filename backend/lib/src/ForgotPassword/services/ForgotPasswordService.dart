import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ForgotPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ForgotPassword/repositories/ForgotPasswordRepository.dart';

import 'package:logging/logging.dart';


/// Serviço responsável como intermediário entre as requisições e o repository
class ForgotPasswordService {
  static final _log = Logger('ForgotPasswordService');

  //-----------------------------
  //            create
  //-----------------------------
  /// Requisição de criação de nova instância
  Future<Response> createForgotPassword(
    ForgotPasswordModel forgotModel,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'forgot_password_requested',
      }.toString());

      final repository = context.read<ForgotPasswordRepository>();

      return repository.createForgotPassword(forgotModel);
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
  //            get
  //-----------------------------
  /// Requisição de atualização de instância
  Future<Response> getForgotPassword(
    ForgotPasswordModel forgotModel,
    RequestContext context,
  ) async {
    try {
      _log.info({
        'event': 'reset_password_requested',
        'reset_id': forgotModel.code,
      }.toString());

      final repository = context.read<ForgotPasswordRepository>();

      return repository.getForgotPassword(
        forgotModel,
        context
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'reset_password_failed',
          'reset_id': forgotModel.code,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}