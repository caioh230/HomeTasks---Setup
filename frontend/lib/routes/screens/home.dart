import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/models/table.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/new_table.dart';
import 'package:hometasks/widgets/table_card.dart';
import 'package:hometasks/widgets/plus_button.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTablesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    await Lists.reloadTables();

    this?.setState(() {
      isTablesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TableCard> boards = Lists.boards.values.map((table) => TableCard(table: table)).toList();
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

                    isTablesLoaded ?
                      Lists.boards.isNotEmpty
                        ? Column(
                            children: [
                              for (final table in boards) ...[
                                table,
                                const SizedBox(height: 20),
                              ],
                            ],
                          )
                        : Center(
                            child: Text(
                              "Você não está em nenhum quadro.\nCrie um novo quadro apertando em \"+\".",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                      : Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: [
                              for (int i = 0; i < 2; i++) ...[
                                TableCard(
                                  table: Table(
                                    title: "Carregando...",
                                    members: const {},
                                    role: UserRole.reader,
                                    isActive: true,
                                    isLoading: true,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ],
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
                DashboardPage.globalKey.currentState?.showOverlay(NewTableScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}