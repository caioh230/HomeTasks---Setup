import 'package:flutter/material.dart';
import 'package:hometasks/models/lists.dart';
import 'package:hometasks/models/member.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/board_card.dart';
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
      category: Lists.boards[task.board]?.title ?? 'Indisponível',
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
      category: Lists.boards[task.board]?.title ?? 'Indisponível',
    );
  }
  
  static AppNotification invitedToBoard(Board board, DateTime time) {
    return AppNotification(
      type: NotificationType.icon,
      icon: Icons.mail_rounded,
      backgroundColor: const Color(0xFFFFE7BE),
      iconColor: const Color(0xFF7A4B00),
      title: 'Você foi convidado para o quadro',
      subtitle: '"${board.title}"',
      time: time,
      actions: true,
    );
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notification.isAvatar
                      ? _buildAvatar()
                      : _buildIcon(),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: notification.title,
                                style: TextStyle(
                                  color: notification.titleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: notification.subtitle.isNotEmpty ? ' ${notification.subtitle}' : '',
                                style: const TextStyle(
                                  color: Color(0xFF444444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Text(
                              TaskCard.dateFormat(notification.time),
                              style: const TextStyle(
                                color: Color(0xFF9A9A9A),
                                fontSize: 12,
                              ),
                            ),

                            if (notification.category != null) ... [
                              Text(
                                " • ",
                                style: const TextStyle(
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                notification.category!,
                                style: TextStyle(
                                  color: notification.category == 'Urgente' ? Colors.red : const Color(0xFF9A9A9A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]
                          ],
                        ),

                        if (notification.actions)
                          const SizedBox(height: 14),

                        if (notification.actions)
                          Row(
                            children: [
                              BasicButton(
                                text: 'Aceitar',
                                onTap: () {
                                  // TODO
                                },
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                textSize: 13,
                              ),

                              BasicButton(
                                text: 'Recusar',
                                onTap: () {
                                  // TODO
                                },
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                textSize: 13,
                                pressedColor: const Color(0xFFC1C2C9),
                                backgroundColor: const Color(0xFFE1E2E9),
                                textColor: const Color(0xFF414751),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (notification.dangerBorder)
            Container(
              width: 4,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: notification.backgroundColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        notification.icon,
        color: notification.iconColor ?? const Color(0xFF276EF1),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        BoardCard.avatar(
          id: notification.userId!,
          size: 42,
        ),

        if (notification.checkmark)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
      ],
    );
  }
}