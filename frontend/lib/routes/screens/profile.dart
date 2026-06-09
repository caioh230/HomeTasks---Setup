import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/edit_profile.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/table_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _checkLoaded() async {
    while (!Lists.isTablesLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {});
    
    while (!Lists.isTasksLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _checkLoaded();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Avatar(id: UserAccount.userId, size: 100),
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
                      Lists.tasks.values.where((Task task) => task.status == TaskStatus.complete).length.toString().padLeft(2, '0'),
                      "TAREFAS",
                      "CONCLUÍDAS",
                      const Color(0xFF005DA7),
                      !Lists.isTasksLoaded
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _infoSquare(
                      Lists.tables.length.toString().padLeft(2, '0'),
                      "ESPAÇOS",
                      "",
                      const Color(0xFF006B3F),
                      !Lists.isTablesLoaded
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

              if(Lists.isTablesLoaded)
                if(Lists.tables.length > 0)
                  Column(
                    children: [
                      for (final table in Lists.tables.values.toList()) ... [
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
                                SizedBox(width: 80, child: Stack(children: TableCard.prepareAvatars(members: table.members.keys.toList()))) :
                                Icon(Icons.lock_outline, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ],
                  ),
                if(Lists.tables.length < 1)
                  Text("Nenhum ambiente ativo.", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if(!Lists.isTablesLoaded)
                Skeletonizer(
                  child: 
                  Column(
                    children: [
                      for (int i = 0 ; i < 3 ; i++) ... [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: UserRole.reader.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.apartment_outlined, color: UserRole.reader.mainColor),
                            ),
                            title: Text(
                              "Carregando...",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Ambiente • 0 membros"),
                            trailing: SizedBox(width: 80, child: Stack(children: TableCard.prepareAvatars(members: ['', '', ''])))
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ],
                  ),
                ),
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
    bool skeletonCond
  ) {
    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Skeletonizer(
            enabled: skeletonCond,
            child: Text(
              num,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
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