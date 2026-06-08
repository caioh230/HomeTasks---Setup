import 'dart:ui';

import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/update.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/widgets/table_card.dart';

class EditTableWidget extends StatefulWidget {
  final Table table;
  final State<TableCard>? card;
  const EditTableWidget({
    super.key,
    required this.table,
    this.card,
  });

  @override
  State<EditTableWidget> createState() => _EditTableWidgetState();
}

class _EditTableWidgetState extends State<EditTableWidget> {
  late Table copiedTable = Table.copy(widget.table);
  late final TextEditingController _titleController = TextEditingController(text: copiedTable.title);
  late final TextEditingController _descriptionController = TextEditingController(text: copiedTable.description ?? "");
  bool _closePressed = false;

  void saveChanges() async {
    if(copiedTable.title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do quadro não pode ser vazio!')),
      );
      return;
    }
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await BackendUpdate.editTable(
        id: copiedTable.id!,
        name: copiedTable.title,
        description: copiedTable.description,
        icon: Table.getStringFromIcon(copiedTable.icon),
        isActive: copiedTable.isActive,
      );
      
      navigator.pop();
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        widget.card?.setState(() {
          widget.table.title = copiedTable.title;
          widget.table.description = copiedTable.description;
          widget.table.isActive = copiedTable.isActive;
          widget.table.icon = copiedTable.icon;
        });
        navigator.pop();
      } else {
        navigator.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao atualizar quadro (${response.statusCode})',
            ),
          ),
        );
      }
    } catch (e) {
      navigator.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar quadro: ${e}'),
        ),
      );
    }
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
                                widget.table.title,
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
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'NOME DO QUADRO',
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
                            maxLines: 1,
                            maxLength: 25,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              hintText: 'Ex: Nossa Casa, Escritório Central...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusColor: Colors.grey.shade500,
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            controller: _titleController,
                            onChanged: (value) => setState(() {
                              copiedTable.title = value;
                            }),
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
                                  'ÍCONE DO QUADRO',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Color(0xFF414751),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (final entry in [
                                      {
                                        'label': 'Residência',
                                        'icon': Icons.home_outlined,
                                      },
                                      {
                                        'label': 'Trabalho',
                                        'icon': Icons.home_work_outlined,
                                      },
                                      {
                                        'label': 'Apartamento',
                                        'icon': Icons.apartment_outlined,
                                      },
                                    ].asMap().entries) ...[
                                      Builder(
                                        builder: (context) {
                                          final option = entry.value;
                                          final isSelected = copiedTable.icon == option['icon'] as IconData;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Material(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(16),
                                              child: InkWell(
                                                onTap: () => setState(() => copiedTable.icon = option['icon'] as IconData),
                                                borderRadius: BorderRadius.circular(16),
                                                hoverColor: const Color(0xFF1067B4).withValues(alpha: 0.08),
                                                splashColor: const Color(0xFF1067B4).withValues(alpha: 0.15),
                                                highlightColor: const Color(0xFF1067B4).withValues(alpha: 0.10),
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 100),
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    color: isSelected ? const Color(0xFF1067B4).withValues(alpha: 0.12) : Colors.transparent,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                                                        child: Icon(
                                                          option['icon'] as IconData,
                                                          size: 32,
                                                          color: isSelected ? const Color(0xFF1067B4) : Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 12),
                                                        child: Text(
                                                          option['label'] as String,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: isSelected ? const Color(0xFF1067B4) : Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'DESCRIÇÃO DO QUADRO',
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
                              hintText: 'O que define este quadro?',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusColor: Colors.grey.shade500,
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            controller: _descriptionController,
                            onChanged: (value) => setState(() => copiedTable.description = value),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'TRANCAR QUADRO',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Color(0xFF414751),
                            ),
                          ),
                          subtitle: const Text(
                            'Impede a criação e edição de tarefas neste quadro.',
                          ),
                          value: !copiedTable.isActive,
                          onChanged: (value) {
                            setState(() {
                              copiedTable.isActive = !(value ?? false);
                            });
                          },
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
                      ],
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
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}