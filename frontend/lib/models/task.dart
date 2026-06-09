import 'package:flutter/material.dart';

enum TaskPriority {
  high('Alta', Color(0x3FFF0000), Color(0xFFDF0000)),
  medium('Média', Color(0x3FFFCA00), Color(0xFFD38800)),
  low('Baixa', Color(0x3F00CF3F), Color(0xFF006D36));

  final String value;
  final Color mainColor;
  final Color backgroundColor;
  const TaskPriority(
    this.value,
    this.backgroundColor,
    this.mainColor
  );
}

enum TaskStatus {
  notStarted('Não iniciado', Icons.calendar_today_outlined),
  inProgress('Em andamento', Icons.trending_up_outlined),
  complete('Concluído', Icons.check);

  final String value;
  final IconData icon;
  const TaskStatus(
    this.value,
    this.icon
  );
}

class Task {
  String? id;
  String title;
  String? description;
  String? table;
  List<String> accountable;
  TaskPriority? priority;
  DateTime expiration;
  DateTime? completedAt;
  String? completedBy;
  TaskStatus status;

  Task({
    this.id,
    required this.title,
    required this.expiration,
    required this.accountable,
    this.description,
    this.priority,
    this.table,
    this.status = TaskStatus.notStarted,
    this.completedAt,
    this.completedBy,
  });

  static copy(Task task) {
    return Task(
      id: task.id,
      title: task.title,
      expiration: task.expiration,
      accountable: task.accountable,
      description: task.description,
      priority: task.priority,
      table: task.table,
      status: task.status,
      completedAt: task.completedAt,
      completedBy: task.completedBy,
    );
  }
}
