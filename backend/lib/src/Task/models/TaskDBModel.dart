import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Tabela para ser retornada pelo banco remoto
class TaskDBModel {
  ///Componentes do modelo
  TaskDBModel({
    required this.id,
    required this.taskStatus,
    required this.name,
    required this.criadoPor,
    required this.idTable,
    required this.timeLimit,
    this.priority,
    this.description,
    this.completedAt,
    this.completedBy,
    this.accountable
  });

  ///Conversão de Map para DBModel
  factory TaskDBModel.toModel ( Map<String, dynamic> map){
    return TaskDBModel(
      id: map['id'].toString(),
      taskStatus: map['taskStatus'].toString(),
      name:  map['name'].toString(),
      criadoPor:  map['criadoPor'].toString(),
      description: map['description']?.toString(),
      timeLimit: DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String(),
      completedAt: map['completedAt'] != null ? DateTime
        .parse(map['completedAt'].toString())
        .toIso8601String() : null,
      completedBy: map['criadoPor']?.toString(),
      idTable: map['idTable'].toString(),
      priority: map['priority']?.toString()
    );
  }

  ///Conversão de DocumentSnapshot para model
  factory TaskDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

      return TaskDBModel(
        id: doc.id,
        taskStatus: dados['taskStatus'].toString(),
        name:  dados['name'].toString(),
        criadoPor:  dados['criadoPor'].toString(),
        description:  dados['description']?.toString(),
        timeLimit: DateTime
          .parse(dados['timeLimit'].toString())
          .toIso8601String(),
        completedAt: dados['completedAt'] != null ? DateTime
          .parse(dados['completedAt'].toString())
          .toIso8601String() : null,
        completedBy: dados['criadoPor']?.toString(),
        idTable: dados['idTable'].toString(),
        accountable: (dados['accountable'] as List).cast<String>(),
        priority: dados['priority'].toString()
      );
  }

  ///Campo id
  final String id;
  ///Campo taskStatus
  final String taskStatus;
  ///Campo name
  final String name;
  ///Campo criadoPor
  final String criadoPor;
  ///Campo priority
  final String? priority;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String timeLimit;
  ///Campo completedAt
  final String? completedAt;
  ///Campo completedBy
  final String? completedBy;
  ///Campo idTable
  final String idTable;
  ///Campo accountable
  final List<String>? accountable;

  
  ///Conversão para tipo Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'taskStatus': taskStatus,
      'name': name,
      'criadoPor': criadoPor,
      'description': description,
      'timeLimit': timeLimit,
      'completedAt': completedAt,
      'completedBy': completedBy,
      'idTable': idTable,
      'priority': priority,
      'accountable': accountable
    };
  }
}
