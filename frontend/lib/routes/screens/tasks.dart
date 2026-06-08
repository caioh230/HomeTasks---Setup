import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hometasks/core/services/update.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/new_task.dart';
import 'package:hometasks/widgets/plus_button.dart';
import 'package:hometasks/widgets/task_card.dart';
import 'package:skeletonizer/skeletonizer.dart';


class TasksScreen extends StatefulWidget {
  final String? table; //Table filtering
  const TasksScreen({
    super.key,
    this.table,
  });
  
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if(Lists.isTasksLoaded) return;

    await Lists.reloadTasks();

    Lists.isTasksLoaded = true;
    if(mounted) {
      setState(() {});
    }
  }

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

    void changeTaskStatus(Task task, TaskStatus oldStatus, TaskStatus newStatus) async {
      try {
        final response = await BackendUpdate.setTaskStatus(
          id: task.id!,
          idTable: task.table!,
          status: newStatus,
          completedAt: newStatus == TaskStatus.complete ? DateTime.now() : null);
        if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202) {
          setState(() {
            task.status = oldStatus;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao mudar status de tarefa (${response.statusCode})',
              ),
            ),
          );
        }
      } catch (e) {
        setState(() {
          task.status = oldStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao mudar status de tarefa: ${e}'),
          ),
        );
      }
    }

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
                            final filteredTasks = Lists.tasks.values.where((task) => task.status == status && (widget.table == null || task.table == widget.table)).toList();
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
                                          TaskStatus oldStatus = task.status;
                                          task.status = status;
                                          changeTaskStatus(task, oldStatus, status);
                                        }
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
                                              if(Lists.isTasksLoaded)
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
                                                        child: TaskCard(task: filteredTasks[i], screen: this),
                                                      ),
                                                    ),
                                                    childWhenDragging: Opacity(
                                                      opacity: 0.3,
                                                      child: TaskCard(task: filteredTasks[i], screen: this),
                                                    ),
                                                    child: TaskCard(task: filteredTasks[i], screen: this),
                                                  ),
                                                ],

                                              if(!Lists.isTasksLoaded)
                                                for (int i = 0; i < 3; i++) ...[
                                                  if (i != 0) const SizedBox(height: 20),

                                                  Skeletonizer(
                                                    enabled: true,
                                                    child: SizedBox(
                                                      width: 320,
                                                      child: TaskCard(
                                                        task: Task(
                                                          title: 'Carregando...', expiration: DateTime.now().add(const Duration(hours: 1)),
                                                          accountable: [],
                                                        ),
                                                      ),
                                                    ),
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
                        DashboardPage.globalKey.currentState?.showOverlay(NewTaskScreen(forceTable: widget.table));
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