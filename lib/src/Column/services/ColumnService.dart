import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Column/models/ColumnModel.dart';
import 'package:hometasks/src/Column/repositories/ColumnRepository.dart';

///Classe intermediária das requisições
class ColumnService {
  //-----------------------------
  //            create
  //-----------------------------
  ///Solicitação de criação
  Future<Response> createColumn(ColumnModel column) async {
    try{
      return ColumnRepository().createColumn(column);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read
  //-----------------------------
  ///Solicitação de leitura
  Future<Response> readColumn(String id, RequestContext context) async{
    try{
      return ColumnRepository().readColumn(id);

    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            update
  //-----------------------------
  ///Solicitação de atualização
  Future<Response> updateColumn(String id, ColumnModel column) async{
    try{
      return ColumnRepository().updateColumn(id, column);
    }catch(e){
      throw Exception(e);
    }
  }

  //-----------------------------
  //            delete
  //-----------------------------
  ///Solicitação de remoção
  Future<Response> deleteColumn(String id) async{
    try{
      return ColumnRepository().deleteColumn(id);
    }catch(e){
      throw Exception(e);
    }
  }
}
