import 'package:flutter/material.dart' hide Table;

import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/member.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/widgets/task_card.dart';

enum NotificationDrawType {
  icon,
  avatar,
}

enum NotificationType {
  taskInvite,
  taskExpiringIn,
  taskCompleted,
  invitedToTable,
  dummy,
}

class AppNotification {
  final NotificationType notificationType;
  final NotificationDrawType drawType;

  // Icon mode
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;

  // Avatar mode
  final String? userId;
  final bool checkmark;

  final String title;
  final String subtitle;

  final DateTime time;
  final String? category;

  final Color titleColor;

  final bool actions;
  final bool dangerBorder;

  final String? relationshipId;

  final Task? task;

  const AppNotification({
    required this.notificationType,
    required this.drawType,

    // Icon mode
    this.icon,
    this.backgroundColor,
    this.iconColor,

    // Avatar mode
    this.userId,
    this.checkmark = false,

    required this.title,
    required this.subtitle,

    required this.time,
    this.category,

    this.titleColor = const Color(0xFF2E2E2E),

    this.actions = false,
    this.dangerBorder = false,

    this.relationshipId,

    this.task,
  });

  bool get isAvatar => drawType == NotificationDrawType.avatar;
  
  static AppNotification taskInvite(Task task, Member invitedBy, DateTime time) {
    return AppNotification(
      notificationType: NotificationType.taskInvite,
      drawType: NotificationDrawType.icon,
      icon: Icons.add_task_outlined,
      backgroundColor: const Color(0xFFEAF1FB),
      title: 'Nova tarefa atribuída a você por ${invitedBy.username}:',
      subtitle: task.title,
      time: time,
      category: Lists.tables[task.table]?.title ?? 'Indisponível',
      titleColor: const Color(0xFF1067B4),
      actions: true,
    );
  }

  static AppNotification taskExpiringIn(Task task, DateTime time) {
    return AppNotification(
      notificationType: NotificationType.taskExpiringIn,
      drawType: NotificationDrawType.icon,
      icon: Icons.warning_rounded,
      backgroundColor: const Color(0xFFFFECEC),
      iconColor: Colors.red,
      title: 'Prazo expirando',
      subtitle: '${TaskCard.dateFormat(task.expiration).toLowerCase()}:\n${task.title}',
      time: time,
      category: 'Urgente',
      titleColor: Colors.red,
      dangerBorder: true,
    );
  }
  
  static AppNotification taskCompleted(Task task, String completedBy, DateTime time) {
    Member? member = Lists.tables[task.table]?.members[completedBy];
    return AppNotification(
      notificationType: NotificationType.taskCompleted,
      drawType: NotificationDrawType.avatar,
      userId: member?.id ?? "",
      checkmark: true,
      title: member?.username ?? "Inválido",
      subtitle: 'Concluiu a tarefa:\n${task.title}',
      time: time,
      category: Lists.tables[task.table]?.title ?? 'Indisponível',
    );
  }
  
  static AppNotification invitedToTable(String relationshipId, Table table, DateTime time) {
    return AppNotification(
      relationshipId: relationshipId,
      notificationType: NotificationType.invitedToTable,
      drawType: NotificationDrawType.icon,
      icon: Icons.mail_rounded,
      backgroundColor: const Color(0xFFFFE7BE),
      iconColor: const Color(0xFF7A4B00),
      title: 'Você foi convidado para o quadro',
      subtitle: '"${table.title}"',
      time: time,
      actions: true,
    );
  }

  static AppNotification dummy() {
    return AppNotification(
      notificationType: NotificationType.dummy,
      drawType: NotificationDrawType.icon,
      icon: Icons.person,
      backgroundColor: const Color.fromARGB(255, 200, 201, 202),
      iconColor: const Color.fromARGB(255, 86, 87, 90),
      title: 'Carregando...',
      subtitle: 'Carregando...',
      time: DateTime.now(),
    );
  }
}
