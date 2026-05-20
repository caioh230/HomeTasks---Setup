import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Tabela para ser retornada pelo banco remoto
class RelationshipDBModel {
  ///Componentes do modelo
  RelationshipDBModel({
    required this.id,
    required this.idRole,
    required this.idTable,
    required this.roleName,
    required this.tableName,
  });

  ///Conversão de Map para DBModel
  factory RelationshipDBModel.toModel ( Map<String, dynamic> map){
    return RelationshipDBModel(
      id: map['id'].toString(),
      idRole: map['idRole'].toString(),
      idTable: map['idTable'].toString(),
      roleName: map['roleName'].toString(),
      tableName: map['tableName'].toString(),
    );
  }

  ///Conversão de DocumentSnapshot para model
  factory RelationshipDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return RelationshipDBModel(
      id: doc.id,
      idRole: dados['idRole'].toString(),
      idTable: dados['idTable'].toString(),
      roleName: dados['roleName'].toString(),
      tableName: dados['tableName'].toString(),
    );
  }

  ///Campo id
  final String id;
  ///Campo idRole
  final String idRole;
  ///Campo idTable
  final String idTable;
  ///Campo roleName
  final String roleName;
  ///Campo tableName
  final String tableName;
  
  ///Conversão para tipo Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'idRole': idRole,
      'idTable': idTable,
      'roleName': roleName,
      'tableName': tableName,
    };
  }
}
