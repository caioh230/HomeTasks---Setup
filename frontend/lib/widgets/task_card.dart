import 'package:flutter/material.dart';
import 'package:hometasks/models/lists.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/widgets/table_card.dart';
import 'package:hometasks/widgets/edit_task.dart';
import 'package:intl/intl.dart';
import 'package:hometasks/extensions/string.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  Color get _dateColor {
    if(task.status == TaskStatus.complete) {
      if(task.expiration.difference(task.completedAt!).inMinutes > 0) {
        return Color(0xFF006D36);
      } else {
        return Colors.red.shade300;
      }
    } else if(task.expiration.difference(DateTime.now()).inMinutes < 0) {
      return Colors.red.shade300;
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: task.status == TaskStatus.complete ? Colors.black.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      Lists.boards[task.table]?.title ?? 'Indisponível',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    if (task.priority != null) ... [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: task.priority!.backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          task.priority!.value.toUpperCase(),
                          style: TextStyle(
                            color: task.priority!.mainColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: task.status == TaskStatus.complete ? TextDecoration.lineThrough : null,
                    color: task.status == TaskStatus.complete ? Colors.grey.shade600 : null
                  ),
                ),

                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    task.description!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 70,
                      child: Stack(
                        children: TableCard.prepareAvatars(members: task.members),
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          task.status.icon,
                          size: 20,
                          color: _dateColor
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateFormat(task.status == TaskStatus.complete ? task.completedAt! : task.expiration),
                          style: TextStyle(
                            color: _dateColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          if (task.status == TaskStatus.inProgress) ... [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // TO DO
        showDialog(context: context, builder: (context) =>
          EditTaskWidget(task: task),
        );
      },
    );
  }

  static String dateFormat(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final target = DateTime(date.year, date.month, date.day, date.hour, date.minute);

    final difference = target.difference(today).inDays;
    final time = DateFormat('HH:mm').format(date);
    switch (difference) {
      case 0: {
        // Hoje
        final diffHours = target.difference(today).inHours;
        if(diffHours.abs() < 1) {
          // A diferença é menor que 1 hora
          final diffMinutes = target.difference(today).inMinutes;
          if(diffMinutes > 0) {
            return 'Em $diffMinutes minutos';
          } else {
            return 'Há ${-diffMinutes} minutos';
          }
        }
        else if(diffHours.abs() < 12) {
          // A diferença de horas é pouca demais para usar "Hoje, HH:mm"
          if(diffHours > 0) {
            return 'Em $diffHours horas';
          } else {
            return 'Há ${-diffHours} horas';
          }
        } else {
          return 'Hoje, $time';
        }
      }
      case -1:
        return 'Ontem, $time';
      case 1:
        return 'Amanhã, $time';
    }

    if (difference.abs() < 7) {
      return DateFormat('E, HH:mm', 'pt_BR').format(date).replaceAll(".", "").toTitleCase();
    }

    if (difference > 0) {
      return 'Em $difference dias';
    } else {
      return '${difference.abs()} dias atrás';
    }
  }
}