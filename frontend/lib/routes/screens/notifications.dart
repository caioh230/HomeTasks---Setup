import 'package:flutter/material.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/notification.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/widgets/notification_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  void _reloadNotifs() async {
    await Lists.reloadNotifications();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _reloadNotifs();
  }

  @override
  Widget build(BuildContext context) {
    final todayNotifs = Lists.notifications.where((notif) => DateTime.now().difference(notif.time!).inDays < 1).toList();
    final previousNotifs = Lists.notifications.where((notif) => DateTime.now().difference(notif.time!).inDays >= 1).toList();
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  BackButton(
                    color: const Color(0xFF1067B4),
                    onPressed: () {
                      DashboardPage.globalKey.currentState?.closeOverlay();
                      Lists.isNotifsLoaded = false;
                    }
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Notificações',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// TODAY
              if(todayNotifs.length > 0 || !Lists.isNotifsLoaded) ... [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hoje',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E7FF),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${todayNotifs.length} novas',
                        style: TextStyle(
                          color: Color(0xFF276EF1),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if(Lists.isNotifsLoaded) ... [
                  for (int i = 0 ; i < todayNotifs.length ; i++) ... [
                    if(i != 0)
                      const SizedBox(height: 16),
                    NotificationCard(notification: todayNotifs[i]),
                  ],
                ] else ... [
                  for (int i = 0 ; i < 2 ; i++) ... [
                    if(i != 0)
                      const SizedBox(height: 16),
                    Skeletonizer(
                      enabled: true,
                      child: NotificationCard(notification: AppNotification.dummy()),
                    ),
                  ],
                ]
              ],

              if(previousNotifs.length > 0 || !Lists.isNotifsLoaded) ... [
                if(todayNotifs.length > 0 || !Lists.isNotifsLoaded)
                  const SizedBox(height: 32),

                const Text(
                  'Anteriormente',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                const SizedBox(height: 20),
                
                if(Lists.isNotifsLoaded) ... [
                  for (int i = 0 ; i < previousNotifs.length ; i++) ... [
                    if(i != 0)
                      const SizedBox(height: 16),
                    NotificationCard(notification: previousNotifs[i]),
                  ],
                ] else ... [
                  for (int i = 0 ; i < 3 ; i++) ... [
                    if(i != 0)
                      const SizedBox(height: 16),
                    Skeletonizer(
                      enabled: true,
                      child: NotificationCard(notification: AppNotification.dummy()),
                    ),
                  ],
                ],
              ],

              if(Lists.isNotifsLoaded && todayNotifs.length == 0 && previousNotifs.length == 0) ... [
                Center(
                  child: const Text(
                    "Você não tem nenhuma notificação.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6C6C6C),
                    ),
                  )
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}