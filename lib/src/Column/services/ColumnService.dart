import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Column/models/ColumnModel.dart';
import 'package:hometasks/src/Column/repositories/ColumnRepository.dart';

///Classe intermediária das requisições
class ColumnService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createColumn(
    ColumnModel column,
    RequestContext context
    ) async {
      try{
        final repository = context.read<ColumnRepository>();

        return repository.createColumn(column);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readColumn(
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<ColumnRepository>();

        return repository.readColumn(id);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateColumn(
    String id, 
    ColumnModel column,
    RequestContext context
    ) async{
      try{
        final repository = context.read<ColumnRepository>();

        return repository.updateColumn(id, column);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteColumn(
    String id,
    RequestContext context
    ) async{
      try{
        final repository = context.read<ColumnRepository>();

        return repository.deleteColumn(id);
      }catch(e){
        throw Exception(e);
      }
  }
}
