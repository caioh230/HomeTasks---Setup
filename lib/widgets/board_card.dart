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

class Board {
  String? id;
  String title;
  List<String> members;
  UserRole role;
  bool isActive;
  IconData icon;

  Board({
    this.id,
    required this.title,
    required this.members,
    this.role = UserRole.reader,
    this.isActive = true,
    this.icon = Icons.home_outlined,
  });
}

class BoardCard extends StatelessWidget {
  final Board board;

  const BoardCard({
    super.key,
    required this.board,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: 1, blurRadius: 1, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: board.role.backgroundColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Icon(
                  board.icon,
                  color: board.role.mainColor,
                  size: 28,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: board.role.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  board.role.value.toUpperCase(),
                  style: TextStyle(
                    color: board.role.mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Title
          Text(
            board.title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900
            ),
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 70,
                child: Stack(
                  children: prepareAvatars(board.members),
                ),
              ),

              const SizedBox(width: 12),
              Text(
                '${board.members.length} membro(s)',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 18),

          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: board.isActive ? Colors.green : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    board.isActive ? 'Ativo' : 'Visualização apenas',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              Icon(
                Icons.arrow_forward,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static List<Widget> prepareAvatars(List<String> members) {
    final List<Widget> avatars = [];
    for (int i = 0; i < members.length; i++) {
      String member = members[i];
      if(members.length > 3 && i >= 2) {
        avatars.add(numAvatar(num: members.length - i, offset: i * 20));
        break;
      } else {
        avatars.add(avatar(image: "https://i.pravatar.cc/100?img=$i", offset: i * 20));
      }
    }
    return avatars;
  }

  static Widget numAvatar({required int num, double size = 34.0, double offset = 0.0}) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.grey.shade300,
        ),
        child: Center(
          child: Text(
            '+$num',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  static Widget avatar({required String image, double size = 34.0, double offset = 0.0}) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}