import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Tabela para ser retornada pelo banco remoto
class TaskDBModel {
  ///Componentes do modelo
  TaskDBModel({
    required this.id,
    required this.idColumn,
    required this.name,
    required this.criadoPor,
     required this.idTable,
    this.description,
    this.timeLimit,
  });

  ///Conversão de Map para DBModel
  factory TaskDBModel.toModel ( Map<String, dynamic> map){
    return TaskDBModel(
      id: map['id'].toString(),
      idColumn: map['idColumn'].toString(),
      name:  map['name'].toString(),
      criadoPor:  map['criadoPor'].toString(),
      description:  map['description'].toString(),
      timeLimit: DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String(),
      idTable: map['idTable'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para model
  factory TaskDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

      return TaskDBModel(
        id: doc.id,
        idColumn: dados['idColumn'].toString(),
        name:  dados['name'].toString(),
        criadoPor:  dados['criadoPor'].toString(),
        description:  dados['description'].toString(),
        timeLimit: DateTime
          .parse(dados['timeLimit'].toString())
          .toIso8601String(),
        idTable: dados['idTable'].toString()
      );
  }

  ///Campo id
  final String id;
  ///Campo idColumn
  final String idColumn;
  ///Campo name
  final String name;
  ///Campo criadoPor
  final String criadoPor;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String? timeLimit;
  ///Campo idTable
  final String idTable;

  
  ///Conversão para tipo Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'idColumn': idColumn,
      'name': name,
      'criadoPor': criadoPor,
      'description': description,
      'timeLimit': timeLimit,
      'idTable': idTable
    };
  }
}
