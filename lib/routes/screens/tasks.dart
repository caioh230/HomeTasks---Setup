
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hometasks/widgets/plus_button.dart';
import 'package:hometasks/widgets/task_card.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with TickerProviderStateMixin {
  final List<Task> tasks = [
    Task(
      id: "asdaiwjekla",
      title: "Limpar caixa do gato",
      desc: "Trocar toda a areia e higienizar a base com desinfetante pet.",
      members: ["test@gmail.com"],
      priority: TaskPriority.high,
      expiration: DateTime.now().add(const Duration(hours: 6)),
      status: TaskStatus.notStarted,
    ),
    Task(
      id: "grehlskdpo",
      title: "Compras da Semana",
      desc: "Lista no bloco de notas da geladeira. Focar em frutas, carne e produtos de limpeza.",
      members: ["test@gmail.com", "test2@gmail.com"],
      expiration: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.notStarted,
    ),
    Task(
      id: "qtriojhksda",
      title: "Organizar Home Office",
      desc: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["test@gmail.com"],
      expiration: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.inProgress,
    ),
    Task(
      id: "lfgdnmjhe",
      title: "Regar as Plantas",
      desc: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["test@gmail.com"],
      expiration: DateTime.now().add(const Duration(hours: 3)),
      status: TaskStatus.inProgress,
    ),
    Task(
      id: "gregfsdaz",
      title: "Lavar a louça do jantar",
      members: ["test@gmail.com"],
      expiration: DateTime.now().add(const Duration(hours: 8)),
      status: TaskStatus.complete,
      completedAt: DateTime.now().subtract(const Duration(hours: 2))
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ScrollController horizontalController = ScrollController();
    Ticker? ticker;
    Offset? lastPointer;
    void startAutoScrollTicker() {
      ticker ??= createTicker((elapsed) {
        if (lastPointer == null || !horizontalController.hasClients) return;

        const edge = 75.0;
        const speed = 8.0;
        final screenWidth = MediaQuery.of(context).size.width;
        final x = lastPointer!.dx;
        double offset = horizontalController.offset;

        if (x < edge) {
          offset -= speed;
        } else if (x > screenWidth - edge) {
          offset += speed;
        } else {
          return;
        }
        horizontalController.jumpTo(offset.clamp(0.0, horizontalController.position.maxScrollExtent));
      });
      ticker!.start();
    }
    void stopAutoScrollTicker() {
      ticker?.stop();
      lastPointer = null;
    }

    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quadro de Tarefas',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Organize o local de forma editorial e flúida.\nArraste e solte para atualizar.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final status in [TaskStatus.notStarted, TaskStatus.inProgress, TaskStatus.complete]) ... [
                          (() {
                            final filteredTasks = tasks.where((task) => task.status == status).toList();
                            return Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          status.value,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "${filteredTasks.length}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  DragTarget<Task>(
                                    onWillAcceptWithDetails: (details) {
                                      final task = details.data;
                                      return task.status != status;
                                    },

                                    onAcceptWithDetails: (details) {
                                      final task = details.data;
                                      setState(() {
                                        if(status != task.status) {
                                          task.completedAt = (status == TaskStatus.complete ? DateTime.now() : null);
                                        }
                                        task.status = status;
                                      });
                                    },

                                    builder: (context, candidateData, rejectedData) {
                                      return Container(
                                        width: 320,
                                        height: MediaQuery.of(context).size.height - 410,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: candidateData.isNotEmpty
                                              ? const Color(0xFFE6E9FF)
                                              : const Color(0xFFF2F3FB),
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              for (int i = 0; i < filteredTasks.length; i++) ...[
                                                if (i != 0) const SizedBox(height: 20),

                                                Draggable<Task>(
                                                  data: filteredTasks[i],
                                                  onDragStarted: startAutoScrollTicker,
                                                  onDragEnd: (_) => stopAutoScrollTicker(),

                                                  onDragUpdate: (details) {
                                                    lastPointer = details.globalPosition;
                                                  },
                                                  feedback: Material(
                                                    color: Colors.transparent,
                                                    child: SizedBox(
                                                      width: 320,
                                                      child: TaskCard(task: filteredTasks[i]),
                                                    ),
                                                  ),
                                                  childWhenDragging: Opacity(
                                                    opacity: 0.3,
                                                    child: TaskCard(task: filteredTasks[i]),
                                                  ),
                                                  child: TaskCard(task: filteredTasks[i]),
                                                ),
                                              ],
                                              const SizedBox(height: 60),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          })(),
                        ],
                      ],
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: PlusButton(
                      onTap: () {
                        // TO DO
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}