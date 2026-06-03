import 'package:flutter/material.dart';

enum UserRole {
  owner(
    value: 'Proprietário',
    icon: Icons.admin_panel_settings_outlined,
    description: 'Pode gerenciar todos os aspectos do board, incluindo membros e assinaturas.',
    backgroundColor: Color(0x3F007FFF),
    mainColor: Color(0xFF005DA7),
  ),
  editor(
    value: 'Editor',
    icon: Icons.edit_square,
    description: 'Pode criar, editar e concluir tarefas, mas não pode gerenciar membros.',
    backgroundColor: Color(0x3F00CF3F),
    mainColor: Color(0xFF006D36),
  ),
  reader(
    value: 'Leitor',
    icon: Icons.visibility_outlined,
    description: 'Visualização apenas. Ideal para acompanhamento de tarefas sem permissão de alteração.',
    backgroundColor: Color(0x3F7A7F8C),
    mainColor: Color(0xFF414751),
  );

  final String value;
  final IconData icon;
  final String description;
  final Color mainColor;
  final Color backgroundColor;
  const UserRole({
    required this.value,
    required this.icon,
    required this.description,
    required this.backgroundColor,
    required this.mainColor
  });
}

class Table {
  String? id;
  String title;
  String? description;
  List<String> members;
  UserRole role;
  bool isActive;
  bool isPrivate;
  IconData icon;

  Table({
    this.id,
    required this.title,
    required this.members,
    this.description,
    this.role = UserRole.reader,
    this.isActive = true,
    this.icon = Icons.home_outlined,
    this.isPrivate = false,
  });
}
