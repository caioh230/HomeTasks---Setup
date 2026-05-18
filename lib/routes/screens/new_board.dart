import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/board_card.dart';

class NewBoardScreen extends StatefulWidget {
  const NewBoardScreen({super.key});
  
  @override
  State<NewBoardScreen> createState() => _NewBoardScreenState();
}

class _NewBoardScreenState extends State<NewBoardScreen> {
  Board newBoard = Board(
    title: "",
    members: const [],
    role: UserRole.owner,
    isActive: true,
    icon: Icons.home_outlined,
  );

  void finishCreatingBoard() async {
    if(newBoard.title.trim().isEmpty) {
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

    String title = newBoard.title;
    String? description = newBoard.description;

    // TO DO
    // Trocar o "await Future.delayed" por uma
    // chamada de API para salvar o novo quadro no backend
    await Future.delayed(Duration(seconds: 1)); //placeholder
    //

    navigator.pop(); 
    DashboardPage.globalKey.currentState?.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  BackButton(color: Color(0xFF1067B4), onPressed: () => DashboardPage.globalKey.currentState?.closeOverlay()),
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
              const Text(
                'Organize suas tarefas criando um novo quadro. Adicione membros, defina prazos e acompanhe o progresso de suas atividades.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nome do Espaço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    maxLength: 25,
                    decoration: InputDecoration(
                      hintText: 'Ex: Nossa Casa, Escritório Central...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      focusColor: Colors.grey.shade400,
                      counterText: '',
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    onChanged: (value) => setState(() => newBoard.title = value),
                  ),
                )
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nome do Espaço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
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
                          final isSelected = newBoard.icon == option['icon'] as IconData;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () => setState(() => newBoard.icon = option['icon'] as IconData),
                                borderRadius: BorderRadius.circular(16),
                                hoverColor: const Color(0xFF1067B4).withValues(alpha: 0.08),
                                splashColor: const Color(0xFF1067B4).withValues(alpha: 0.15),
                                highlightColor: const Color(0xFF1067B4).withValues(alpha: 0.10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  width: 110,
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
                                          size: 40,
                                          color: isSelected ? const Color(0xFF1067B4) : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Text(
                                          option['label'] as String,
                                          style: TextStyle(
                                            fontSize: 15,
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
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Breve Descrição (Opcional)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  maxLines: null,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: 'O que define este quadro?',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    focusColor: Colors.grey.shade400,
                    counterText: '',
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (value) => setState(() => newBoard.description = value),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0x3F00CF3F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF006D36)
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 200,
                      child: Text(
                        "Você poderá convidar membros para este quadro assim que ele for criado.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF006D36),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BasicButton(
                onTap: () => finishCreatingBoard(),
                icon: Icon(Icons.add, color: Colors.white),
                text: 'Criar Quadro',
                textSize: 18,
                padding: EdgeInsetsGeometry.all(12),
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 60, top: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}