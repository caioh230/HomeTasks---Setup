import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:hometasks/src/Table/repositories/TableRepository.dart';

///Classe intermediária para as requisições
class TableService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createTable(TableModel table) async {
    try{
      return TableRepository().createTable(table);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readTable(String id, RequestContext context) async{
    try{
      return TableRepository().readTable(id);

    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateTable(String id, TableModel table) async{
    try{
      return TableRepository().updateTable(id, table);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteTable(String id) async{
    try{
      return TableRepository().deleteTable(id);
    }catch(e){
      throw Exception(e);
    }
  }
}
