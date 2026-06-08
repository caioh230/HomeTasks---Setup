import 'package:flutter/material.dart' hide Table;

import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/member.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/widgets/task_card.dart';

enum NotificationType {
  icon,
  avatar,
}

class AppNotification {
  final NotificationType type;

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

  final Task? task;

  const AppNotification({
    required this.type,

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

    this.task,
  });

  bool get isAvatar => type == NotificationType.avatar;
  
  static AppNotification taskInvite(Task task, Member invitedBy, DateTime time) {
    return AppNotification(
      type: NotificationType.icon,
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
      type: NotificationType.icon,
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
  
  static AppNotification taskCompleted(Task task, Member completedBy, DateTime time) {
    return AppNotification(
      type: NotificationType.avatar,
      userId: completedBy.id,
      checkmark: true,
      title: completedBy.username,
      subtitle: 'Concluiu a tarefa:\n${task.title}',
      time: time,
      category: Lists.tables[task.table]?.title ?? 'Indisponível',
    );
  }
  
  static AppNotification invitedToTable(Table table, DateTime time) {
    return AppNotification(
      type: NotificationType.icon,
      icon: Icons.mail_rounded,
      backgroundColor: const Color(0xFFFFE7BE),
      iconColor: const Color(0xFF7A4B00),
      title: 'Você foi convidado para o quadro',
      subtitle: '"${table}"',
      time: time,
      actions: true,
    );
  }
}
