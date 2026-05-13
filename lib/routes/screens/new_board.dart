import 'package:flutter/material.dart';
import 'package:hometasks/widgets/board_card.dart';
//import 'package:hometasks/widgets/back_button.dart';

class NewBoardScreen extends StatefulWidget {
  const NewBoardScreen({super.key});
  
  @override
  State<NewBoardScreen> createState() => _NewBoardScreenState();
}

class _NewBoardScreenState extends State<NewBoardScreen> {
  @override
  Widget build(BuildContext context) {
    Board newBoard = Board(
      title: "",
      members: const [],
      role: UserRole.reader,
      isActive: false,
      icon: Icons.home_work_outlined,
    );

    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              BackButton(color: Color(0xFF1067B4)),
              const SizedBox(width: 12),
              const Text(
                'Criar Novo Quadro',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}