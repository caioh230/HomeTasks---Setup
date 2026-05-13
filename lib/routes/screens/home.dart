import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/new_board.dart';
import 'package:hometasks/widgets/board_card.dart';
import 'package:hometasks/widgets/plus_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<BoardCard> boards = [
    BoardCard(
      board: Board(
        id: "asdhuhawrihasr",
        title: "Minha Casa",
        members: const [
          "test@gmail.com",
          "test2@gmail.com",
          "test3@gmail.com",
        ],
        role: UserRole.owner,
        isActive: true,
      )
    ),
    BoardCard(
      board: Board(
        id: "greasodkwqeasd",
        title: "Apartamento República",
        members: const [
          "test@gmail.com",
          "test2@gmail.com",
          "test3@gmail.com",
          "test4@gmail.com",
        ],
        role: UserRole.editor,
        isActive: true,
        icon: Icons.apartment_outlined,
      )
    ),
    BoardCard(
      board: Board(
        id: "vpoxcjfdwermk",
        title: "Oficina do João",
        members: const [
          "test@gmail.com",
          "test2@gmail.com",
        ],
        role: UserRole.reader,
        isActive: false,
        icon: Icons.home_work_outlined,
      )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meus Quadros',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gerencie os espaços da sua vida e colaboração doméstica.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),

                  boards.isNotEmpty ? Column(
                    children: [
                      for (final board in boards) ...[
                        board,
                        const SizedBox(height: 20),
                      ],
                    ],
                  ) :
                  Center(
                    child:
                    Text(
                      "Você não está em nenhum quadro.\nAdicione um novo quadro apertando em \"+\".",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500))
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 22,
            child: PlusButton(onTap: () {
              DashboardPage.globalKey.currentState?.showOverlay(NewBoardScreen());
            })
          ),
        ],
      ),
    );
  }
}