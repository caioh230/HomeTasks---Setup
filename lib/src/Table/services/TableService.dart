import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:hometasks/src/Table/repositories/TableRepository.dart';

///Classe intermediária para as requisições
class TableService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createTable(
    TableModel table, 
    RequestContext context
    ) async {
      try{
        final repository = context.read<TableRepository>();

        return repository.createTable(table, context);
      }catch(e){
        throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readTable(
    String id, 
    RequestContext context
    ) async{
      try{
        final repository = context.read<TableRepository>();

        return repository.readTable(id, context);
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateTable(
    String id, 
    TableModel table,
    RequestContext context
    ) async{
    try{
      final repository = context.read<TableRepository>();

      return repository.updateTable(id, table, context);
    }catch(e){
      throw Exception(e);
    }

  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteTable(
    String id,
    RequestContext context
    ) async{
    try{
      final repository = context.read<TableRepository>();
      
      return repository.deleteTable(id, context);
    }catch(e){
      throw Exception(e);
    }
  }
}
