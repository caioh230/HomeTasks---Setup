import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/new_board.dart';
import 'package:hometasks/widgets/board_card.dart';
import 'package:hometasks/widgets/plus_button.dart';
import 'package:hometasks/models/lists.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Lists.reloadBoards();
    List<BoardCard> boards = Lists.boards.map((board) => BoardCard(board: board)).toList();
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
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
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 30),

                    boards.isNotEmpty
                        ? Column(
                            children: [
                              for (final board in boards) ...[
                                board,
                                const SizedBox(height: 20),
                              ],
                            ],
                          )
                        : Center(
                            child: Text(
                              "Você não está em nenhum quadro.\nAdicione um novo quadro apertando em \"+\".",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 22,
            child: PlusButton(
              onTap: () {
                DashboardPage.globalKey.currentState
                    ?.showOverlay(NewBoardScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}