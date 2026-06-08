import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ResetPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/models/ResetPasswordModel.dart';
import 'package:hometasks/src/ResetPassword/repositories/ResetPasswordRepository.dart';


///Serviço responsável como intermediário entre as requisições e o repository
class ResetPasswordService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Requisição de criação de nova instância
  Future<Response> createResetPassword(
    ForgotPasswordModel forgotPassword, 
    RequestContext context
    ) async {
      try{
        final repository = context.read<ResetPasswordRepository>();

        return repository.createResetPassword(forgotPassword);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Requisição de atualização de instância
  Future<Response> updateResetPassword(
    String id,
    ResetPasswordModel resetPassword, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<ResetPasswordRepository>();

        return repository.updateResetPassword(id, context, resetPassword);
      }catch(e){
        throw Exception(e);
      }
  }
}
