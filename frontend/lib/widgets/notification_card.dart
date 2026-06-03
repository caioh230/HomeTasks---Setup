import 'package:flutter/material.dart';
import 'package:hometasks/models/notification.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/table_card.dart';
import 'package:hometasks/widgets/task_card.dart';

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
        TableCard.avatar(
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