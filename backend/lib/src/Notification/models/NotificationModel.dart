///Modelo a ser enviado pelas requisições
class NotificationModel {
  ///Estrutura do modelo
  NotificationModel({
    required this.notificationType,
    required this.toUser,
    required this.createdAt,
    this.taskId,
    this.tableId,
    this.fromUser,
  });

  ///Converção de Map para Model
  factory NotificationModel.toModel(Map<String, dynamic> map) {
    return NotificationModel(
      notificationType: map['notificationType'].toString(),
      taskId: map['taskId']?.toString(),
      tableId: map['tableId']?.toString(),
      fromUser: map['fromUser']?.toString(),
      toUser: map['toUser'].toString(),
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  /// Campo notificationType
  final String notificationType;
  /// Campo fromUser
  final String? fromUser;
  /// Campo toUser
  final String toUser;
  /// Campo taskId
  final String? taskId;
  /// Campo tableId
  final String? tableId;
  /// Campo createdAt
  final DateTime createdAt;

  ///Converção de Model para Map
  Map<String, dynamic> toMap() {
    return {
      'notificationType': notificationType,
      'fromUser': fromUser,
      'toUser': toUser,
      'taskId': taskId,
      'tableId': tableId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}