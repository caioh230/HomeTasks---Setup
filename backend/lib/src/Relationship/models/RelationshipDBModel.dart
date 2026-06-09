import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Tabela para ser retornada pelo banco remoto
class RelationshipDBModel {
  ///Componentes do modelo
  RelationshipDBModel({
    required this.id,
    required this.idTable,
    required this.tableName,
    required this.idUser,
    required this.roleName,
    required this.valid,
    this.createdAt,
  });

  ///Conversão de Map para DBModel
  factory RelationshipDBModel.toModel ( Map<String, dynamic> map){
    return RelationshipDBModel(
      id:       map['id'].toString(),
      idTable:  map['idTable'].toString(),
      tableName:map['tableName'].toString(),
      idUser:   map['idUser'].toString(),
      roleName: map['roleName'].toString(),
      valid:    bool.parse(map['valid'].toString()),
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  ///Conversão de DocumentSnapshot para model
  factory RelationshipDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return RelationshipDBModel(
      id:       doc.id,
      idTable:  dados['idTable'].toString(),
      tableName:dados['tableName'].toString(),
      idUser:   dados['idUser'].toString(),
      roleName: dados['roleName'].toString(),
      valid:    bool.parse(dados['valid'].toString()),
      createdAt: dados['createdAt'] != null ? DateTime.parse(dados['createdAt'].toString()) : null,
    );
  }

  ///Campo id
  final String id;
  ///Campo idTable
  final String idTable;
  ///Campo tableName
  final String tableName;
  ///Campo idUser
  final String idUser;
  ///Campo roleName
  final String roleName;
  ///Campo valid
  final bool valid;
  ///Campo createdAt
  final DateTime? createdAt;
  
  ///Conversão para tipo Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'idTable': idTable,
      'tableName': tableName,
      'idUser': idUser,
      'roleName': roleName,
      'valid': valid,
      if(createdAt != null)
        'createdAt': createdAt?.toIso8601String(),
    };
  }
}