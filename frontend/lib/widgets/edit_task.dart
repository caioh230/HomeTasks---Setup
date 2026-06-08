import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/widgets/basic_button.dart';

class EditTaskWidget extends StatefulWidget {
  final Task task;
  const EditTaskWidget({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  late final TextEditingController _dateController = TextEditingController(text: dateFormat(widget.task.expiration));
  bool _closePressed = false;

  void saveChanges() {
    // TO DO
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double height = 720;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          //Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          //Dialog
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                tween: Tween(
                  begin: -height,
                  end: 0,
                ),
                builder: (context, value, childWidget) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: childWidget,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  padding: EdgeInsetsGeometry.all(24),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 275,
                                child: Text(
                                  widget.task.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF005DA7),
                                  ),
                                ),
                              ),
                              InkWell(
                                onHighlightChanged: (value) {
                                  setState(() {
                                    _closePressed = value;
                                  });
                                },
                                onTap: () => Navigator.pop(context),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    color: _closePressed ? Colors.black.withValues(alpha: 0.2) : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.close,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.folder_outlined, size: 16),
                              const SizedBox(width: 10),
                              Text(
                                Lists.tables[widget.task.table!]?.title.toUpperCase() ?? "INVÁLIDO",
                                style: TextStyle(
                                  letterSpacing: 1,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 15, right: 15, top: 18, bottom: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F3FB),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: Color(0xFF414751),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonFormField<TaskStatus>(
                                    initialValue: widget.task.status,
                                    items: TaskStatus.values.map((TaskStatus status) => DropdownMenuItem<TaskStatus>(
                                              value: status,
                                              child: Text(
                                                status.value,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ))
                                        .toList(),

                                    onChanged: (TaskStatus? newValue) {
                                      if (newValue == null) return;
                                      setState(() {
                                        widget.task.status = newValue;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey.shade600,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 15, right: 15, top: 18, bottom: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F3FB),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'PRAZO FINAL',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: Color(0xFF414751),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: _dateController,
                                    readOnly: true,
                                    maxLength: 40,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
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
                                          setState(() {
                                            _dateController.text = dateFormat(pickedDate);
                                            widget.task.expiration = pickedDate;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 15, right: 15, top: 18, bottom: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F3FB),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'PRIORIDADE DA TAREFA',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: Color(0xFF414751),
                                    ),
                                  ),
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
                                                widget.task.priority = (widget.task.priority != priority) ? priority : null;
                                              });
                                            },
                                            child: Container(
                                              width: 92,
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: (widget.task.priority != priority) ? priority.backgroundColor.withValues(alpha: 0.12) : priority.backgroundColor,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: widget.task.priority == priority ? priority.mainColor : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                priority.value,
                                                style: TextStyle(
                                                  color: priority.mainColor,
                                                  fontSize: 15,
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'DESCRIÇÃO DA TAREFA',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Color(0xFF414751),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F3FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              minLines: 4,
                              maxLines: 4,
                              maxLength: 100,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                hintText: 'Adicione detalhes sobre como esta tarefa deve ser concluída...',
                                hintStyle: TextStyle(color: Colors.grey.shade500),
                                focusColor: Colors.grey.shade500,
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              onChanged: (value) => setState(() => widget.task.description = value),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 160,
                                height: 50,
                                child: BasicButton(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  text: "Cancelar",
                                  textSize: 15,
                                  backgroundColor: Color(0x00FFFFFF),
                                  pressedColor: Color(0xFFD8DAE2),
                                  textColor: Color(0xFF005DA7),
                                  onTap: () => Navigator.pop(context),
                                ),
                              ),
                              Container(
                                width: 160,
                                height: 50,
                                child: BasicButton(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  text: "Salvar Alterações",
                                  textSize: 15,
                                  onTap: saveChanges,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String dateFormat(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year, $hours:$minutes';
  }
}