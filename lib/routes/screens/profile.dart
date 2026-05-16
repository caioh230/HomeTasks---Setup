import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/edit_profile.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/board_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              BoardCard.avatar(image: "https://i.pravatar.cc/100?img=1", size: 100),
              const SizedBox(height: 10),

              const Text(
                "Nome de Usuário",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              Text(
                user!.email!,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),
              BasicButton(
                onTap: () => DashboardPage.globalKey.currentState!.showOverlay(EditProfileScreen()),
                icon: Icon(Icons.edit_note, color: Colors.white),
                text: 'Editar perfil',
                textSize: 18,
                padding: EdgeInsetsGeometry.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 90),
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: _infoSquare(
                      "24",
                      "TAREFAS",
                      "CONCLUÍDAS",
                      const Color(0xFF005DA7),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _infoSquare(
                      "03",
                      "ESPAÇOS",
                      "",
                      const Color(0xFF006B3F),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ambientes Ativos",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Ver Todos"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _cardAmbiente(
                titulo: "Residência Principal",
                subtitulo: "Família • 4 Membros",
                corIcone: const Color(0xFF1565C0),
                corFundoIcone: const Color(0xFFE3F2FD),
                icone: Icons.home,
                trailing: SizedBox(
                  width: 80,
                  child: Stack(children: BoardCard.prepareAvatars(["test1@gmail.com", "test2@gmail.com", "test3@gmail.com", "test4@gmail.com"])),
                )
              ),

              const SizedBox(height: 15),

              _cardAmbiente(
                titulo: "Estúdio Criativo",
                subtitulo: "Compartilhado • 2 Membros",
                corIcone: const Color(0xFF2E7D32),
                corFundoIcone: const Color(0xFFE8F5E9),
                icone: Icons.business_center,
                trailing: SizedBox(
                  width: 80,
                  child: Stack(children: BoardCard.prepareAvatars(["test1@gmail.com", "test2@gmail.com", "test3@gmail.com", "test4@gmail.com"])),
                )
              ),

              const SizedBox(height: 15),

              _cardAmbiente(
                titulo: "Refúgio de Fim de Semana",
                subtitulo: "Privado • Por Márcia",
                corIcone: const Color(0xFFD84315),
                corFundoIcone: const Color(0xFFFBE9E7),
                icone: Icons.home_work,
                trailing: const Icon(Icons.lock_outline, color: Colors.grey),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoSquare(
    String num,
    String t1,
    String t2,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            num,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(t1, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (t2.isNotEmpty)
            Text(t2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _cardAmbiente({
    required String titulo,
    required String subtitulo,
    required Color corIcone,
    required Color corFundoIcone,
    required IconData icone,
    required Widget trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: corFundoIcone,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icone, color: corIcone),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: trailing,
      ),
    );
  }
}