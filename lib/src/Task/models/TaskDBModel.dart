import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Tabela para ser retornada pelo banco remoto
class TaskDBModel {
  ///Componentes do modelo
  TaskDBModel({
    required this.id,
    required this.idColumn,
    required this.name,
    this.description,
    this.timeLimit,
    this.idUser,
  });

  ///Conversão de Map para DBModel
  factory TaskDBModel.toModel ( Map<String, dynamic> map){
    return TaskDBModel(
      id: map['id'].toString(),
      idColumn: map['idColumn'].toString(),
      name:  map['name'].toString(),
      description:  map['description'].toString(),
      timeLimit: DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String(),
      idUser: map['idUser'].toString()
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
      description:  dados['description'].toString(),
      timeLimit: DateTime
        .parse(dados['timeLimit'].toString())
        .toIso8601String(),
      idUser: dados['idUser'].toString()
    );
  }

  ///Campo id
  final String id;
  ///Campo idColumn
  final String idColumn;
  ///Campo name
  final String name;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String? timeLimit;
  ///Campo idUser
  final String? idUser;

  
  ///Conversão para tipo Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'idColumn': idColumn,
      'name': name,
      'description': description,
      'timeLimit': timeLimit,
      'idUser': idUser
    };
  }
}
