import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Modelo a ser retornado pelo banco remoto
class NotificationDBModel{
  ///Estrutura a ser seguida
  const NotificationDBModel({
    required this.id,
    required this.notificationType,
    required this.toUser,
    required this.createdAt,
    this.taskId,
    this.tableId,
    this.fromUser,
  });


  ///Conversão de Map para DBModel
  factory NotificationDBModel.toModel(Map<String, dynamic> map) {
    return NotificationDBModel(
      id: map['id'].toString(),
      notificationType: map['notificationType'].toString(),
      taskId: map['taskId']?.toString(),
      tableId: map['tableId']?.toString(),
      fromUser: map['fromUser']?.toString(),
      toUser: map['toUser'].toString(),
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory NotificationDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final dados = doc.data()!;

    return NotificationDBModel(
      id: doc.id,
      notificationType: dados['notificationType'].toString(),
      taskId: dados['taskId']?.toString(),
      tableId: dados['tableId']?.toString(),
      fromUser: dados['fromUser']?.toString(),
      toUser: dados['toUser'].toString(),
      createdAt: DateTime.parse(dados['createdAt'].toString()),
    );
  }

  ///Campo id
  final String id;
  ///Campo notificationType
  final String notificationType;
  ///Campo taskId
  final String? taskId;
  ///Campo tableId
  final String? tableId;
  ///Campo fromUser
  final String? fromUser;
  ///Campo itoUserd
  final String toUser;
  ///Campo createdAt
  final DateTime createdAt;

  /// Conversão de DBModel para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationType': notificationType,
      'taskId': taskId,
      'tableId': tableId,
      'fromUser': fromUser,
      'toUser': toUser,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
