import 'package:flutter/material.dart';
import 'package:hometasks/core/services/delete.dart';
import 'package:hometasks/core/services/update.dart';
import 'package:hometasks/models/notification.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/task_card.dart';

import '../core/utils/lists.dart';

enum InviteStatus {
  pending,
  accepted,
  declined,
}
class NotificationCard extends StatefulWidget {
  final AppNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  InviteStatus status = InviteStatus.pending;

  void acceptedInvite() async {
    switch(widget.notification.notificationType) {
      case NotificationType.invitedToTable: {
        // Convidado a um quadro
        Lists.isTablesLoaded = false;
        Lists.isTasksLoaded = false;
        BackendUpdate.acceptInvite(widget.notification.relationshipId!);
      }

      case NotificationType.taskInvite: {
        // Adicionado a uma tarefa
        Lists.isTasksLoaded = false;

      }

      default: {}
    }
  }
  void declinedInvite() async {
    switch(widget.notification.notificationType) {
      case NotificationType.invitedToTable: {
        // Convidado a um quadro
        BackendDelete.relationship(widget.notification.relationshipId!);
      }

      case NotificationType.taskInvite: {
        // Adicionado a uma tarefa
      }
      
      default: {}
    }
  }

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
                  widget.notification.isAvatar
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
                                text: widget.notification.title,
                                style: TextStyle(
                                  color: widget.notification.titleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.notification.subtitle.isNotEmpty ? ' ${widget.notification.subtitle}' : '',
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
                              TaskCard.dateFormat(widget.notification.time),
                              style: const TextStyle(
                                color: Color(0xFF9A9A9A),
                                fontSize: 12,
                              ),
                            ),

                            if (widget.notification.category != null) ... [
                              Text(
                                " • ",
                                style: const TextStyle(
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.notification.category!,
                                style: TextStyle(
                                  color: widget.notification.category == 'Urgente' ? Colors.red : const Color(0xFF9A9A9A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]
                          ],
                        ),

                        if (widget.notification.actions) ... [
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              if(status == InviteStatus.pending)
                                Row(
                                  children: [
                                    BasicButton(
                                      text: 'Aceitar',
                                      onTap: () {
                                        setState(() {
                                          status = InviteStatus.accepted;
                                          acceptedInvite();
                                        });
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
                                        setState(() {
                                          status = InviteStatus.declined;
                                          declinedInvite();
                                        });
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

                              if(status != InviteStatus.pending)
                                Row(
                                  children: [
                                    Icon(
                                      status == InviteStatus.accepted ? Icons.check : Icons.close_rounded,
                                      color: status == InviteStatus.accepted ? Color(0xFF006D36) : Color(0xFFBA1A1A),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      status == InviteStatus.accepted ? 'Convite aceito'  : 'Convite recusado',
                                      style: TextStyle(
                                        color: status == InviteStatus.accepted ? Color(0xFF006D36) : Color(0xFFBA1A1A),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (widget.notification.dangerBorder)
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
        color: widget.notification.backgroundColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        widget.notification.icon,
        color: widget.notification.iconColor ?? const Color(0xFF276EF1),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Avatar(
          id: widget.notification.userId,
          size: 42,
        ),

        if (widget.notification.checkmark)
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