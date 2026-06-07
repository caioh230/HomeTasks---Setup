import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/edit_profile.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/table_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Table> userTables = [
      Table(
        title: "Residência Principal",
        icon: Icons.home_outlined,
        role: UserRole.owner,
        members: ["1", "2", "3", "4"]
      ),
      Table(
        title: "Estúdio Criativo",
        icon: Icons.home_work_outlined,
        role: UserRole.editor,
        members: ["1", "7", "10", "9"]
      ),
      Table(
        title: "Refúgio do Fim de Semana",
        icon: Icons.lock_outline,
        role: UserRole.reader,
        members: [],
        isPrivate: true
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Avatar(id: "1", size: 100),
              const SizedBox(height: 10),

              Text(
                UserAccount.name ?? "Nome de Usuário",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              Text(
                "@" + (UserAccount.username ?? "usuario"),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),
              BasicButton(
                onTap: () => DashboardPage.globalKey.currentState!.showOverlay(EditProfileScreen()),
                prefixIcon: Icon(Icons.edit_note, color: Colors.white),
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

              for (final table in userTables) ... [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: table.role.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(table.icon, color: table.role.mainColor),
                        ),
                        title: Text(
                          table.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(_boardDescriptor(table)),
                        trailing: !table.isPrivate ?
                            SizedBox(width: 80, child: Stack(children: TableCard.prepareAvatars(members: table.members))) :
                            Icon(Icons.lock_outline, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ]
                )
              ],
              const SizedBox(height: 25),
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

  String _boardDescriptor(Table table) {
    if(table.isPrivate) return "Privado";
    
    String ambient = "Ambiente";
    switch(table.icon) {
      case Icons.home_outlined: ambient = "Residência";
      case Icons.home_work_outlined: ambient = "Trabalho";
      case Icons.apartment_outlined: ambient = "Apartamento";
    }
    return "$ambient • ${table.members.length} ${table.members.length != 1 ? 'membros' : 'membro'}";
  }
}