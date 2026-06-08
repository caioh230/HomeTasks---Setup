import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/post.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/invite_member.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:dotted_border/dotted_border.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController _dateController = TextEditingController();

  final initialDate = DateTime.now();
  late final Task newTask = Task(
    title: '',
    accountable: [],
    expiration: initialDate,
    status: TaskStatus.notStarted,
  );

  void addNewMember() {
    if(newTask.table == null) return;
    DashboardPage.globalKey.currentState!.showOverlay(InviteMemberScreen(table: Lists.tables[newTask.table!]!));
  }

  void saveTask() async {
    if(newTask.title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha um nome válido para a tarefa!')),
      );
      return;
    }

    if(newTask.table == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um quadro ativo para a tarefa!')),
      );
      return;
    }

    if(newTask.expiration == initialDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data para o prazo!')),
      );
      return;
    }

    if(newTask.expiration.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O prazo precisa ser depois da data e hora atual!')),
      );
      return;
    }

    if(newTask.accountable.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um responsável para a tarefa!')),
      );
      return;
    }
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String name = newTask.title;
    String? description = newTask.description;
    List<String> accountable = newTask.accountable;
    DateTime timeLimit = newTask.expiration;
    TaskPriority? priority = newTask.priority;
    TaskStatus status = TaskStatus.notStarted;
    String idTable = newTask.table!;

    try {
      final response = await BackendPost.task(
        idTable: idTable,
        name: name,
        timeLimit: timeLimit,
        status: status,
        accountable: accountable,
        description: description,
        priority: priority,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        navigator.pop();
        Lists.isTasksLoaded = false;
        DashboardPage.globalKey.currentState?.closeOverlay();
      } else {
        navigator.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao criar tarefa (${response.statusCode})',
            ),
          ),
        );
      }
    }
    catch(e) {
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar tarefa: ${e}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(color: Color(0xFF1067B4), onPressed: DashboardPage.globalKey.currentState?.closeOverlay),
                  const SizedBox(width: 12),
                  const Text(
                    'Criar Nova Tarefa',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nome do Espaço',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        maxLength: 40,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Ex: Organizar a dispensa',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusColor: Colors.grey.shade500,
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: (value) => setState(() => newTask.title = value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Espaço',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        items: Lists.tables.values
                            .where((Table table) => table.isActive)
                            .map((Table table) => DropdownMenuItem<String>(
                                  value: table.id,
                                  child: Text(
                                    table.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),

                        onChanged: (newValue) {
                          newTask.accountable.clear();
                          setState(() {
                            newTask.table = newValue;
                          });
                        },

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          border: InputBorder.none,
                          counterText: '',
                        ),

                        hint: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Escolha um quadro...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),

                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade600,
                        ),

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.2, // 🔥 key fix for alignment consistency
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Prazo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        maxLength: 40,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          hintText: 'dd/mm/yyyy, --:--',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final day = pickedDate.day.toString().padLeft(2, '0');
                              final month = pickedDate.month.toString().padLeft(2, '0');
                              final year = pickedDate.year.toString();
                              final hours = pickedTime.hour.toString().padLeft(2, '0');
                              final minutes = pickedTime.minute.toString().padLeft(2, '0');
                              final formattedDate = '$day/$month/$year, $hours:$minutes';
                              setState(() {
                                _dateController.text = formattedDate;
                                newTask.expiration = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        minLines: 4,
                        maxLines: 4,
                        maxLength: 100,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Adicione detalhes sobre como esta tarefa deve ser concluída...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusColor: Colors.grey.shade500,
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: (value) => setState(() => newTask.description = value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Responsável',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if(newTask.table != null)...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: [
                            for (var member in Lists.tables[newTask.table]!.members.keys.toList()) ...[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if(!newTask.accountable.contains(member)) {
                                      newTask.accountable.add(member);
                                    } else {
                                      newTask.accountable.remove(member);
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: newTask.accountable.contains(member)
                                              ? Colors.green
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                      ),
                                      child: Avatar(
                                        id: member,
                                        size: 58.0,
                                        offset: 0.0,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: 90,
                                      child: Text(
                                        member,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    addNewMember();
                                  },
                                  child: DottedBorder(
                                    options: CircularDottedBorderOptions(
                                      color: Colors.grey,
                                      strokeWidth: 2,
                                      dashPattern: const [6, 4],
                                    ),
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add,
                                        size: 25,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Novo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if(newTask.table == null)...[
                      Center(
                        child: Text(
                          'Selecione um quadro antes de selecionar um responsável!',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F3FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bolt_outlined, size: 16, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                "Prioridade da Tarefa",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var priority in [TaskPriority.low, TaskPriority.medium, TaskPriority.high]) ...[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          newTask.priority = (newTask.priority != priority) ? priority : null;
                                        });
                                      },
                                      child: Container(
                                        width: 100,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: (newTask.priority != priority) ? priority.backgroundColor.withValues(alpha: 0.12) : priority.backgroundColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: newTask.priority == priority ? priority.mainColor : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          priority.value,
                                          style: TextStyle(
                                            color: priority.mainColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "Tarefas menores ajudam a manter o fluxo constante.",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    BasicButton(
                      onTap: saveTask,
                      text: 'Salvar Nova Tarefa',
                      textSize: 18,
                      padding: EdgeInsetsGeometry.all(15),
                      margin: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: DashboardPage.globalKey.currentState?.closeOverlay,
                      child: Text(
                        'Descartar tarefa',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}