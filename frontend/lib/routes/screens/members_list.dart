import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/models/table.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/invite_member.dart';

class MembersListScreen extends StatelessWidget {
  final Table table;
  const MembersListScreen({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                table.title.toUpperCase(),
                style: TextStyle(
                  color: Color(0xFF0B7A42),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Equipe Doméstica',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2430),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Gerencie quem tem acesso às tarefas da sua residência.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Color(0xFF666D80),
                ),
              ),


              /// CARD AZUL
              if(table.role == UserRole.owner) ... [
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    DashboardPage.globalKey.currentState?.showOverlay(InviteMemberScreen(table: table));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1565C0),
                          Color(0xFF2D7FE0),
                        ],
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Convidar novo membro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                'Envie um convite para entrar no quadro',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white70,
                          size: 34,
                        )
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 38),

              memberCard(
                image: 'https://i.pravatar.cc/150?img=32',
                name: 'Márcia',
                role: UserRole.owner,
              ),

              const SizedBox(height: 22),

              memberCard(
                image: 'https://i.pravatar.cc/150?img=12',
                name: 'Pedro',
                role: UserRole.editor,
              ),

              const SizedBox(height: 22),

              memberCard(
                image: 'https://i.pravatar.cc/150?img=20',
                name: 'João',
                role: UserRole.reader,
              ),

              const SizedBox(height: 40),

              /// DEFINIÇÕES
              Container(
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F8),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Definições de Acesso',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    accessItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'Proprietário',
                      description:
                      'Pode gerenciar todos os aspectos do quadro, incluindo membros e assinaturas.',
                      color: const Color(0xFF1565C0),
                    ),

                    const SizedBox(height: 26),

                    accessItem(
                      icon: Icons.edit_square,
                      title: 'Editor',
                      description:
                      'Pode criar, editar e concluir tarefas, mas não pode gerenciar membros.',
                      color: const Color(0xFF0A8F32),
                    ),

                    const SizedBox(height: 26),

                    accessItem(
                      icon: Icons.remove_red_eye_outlined,
                      title: 'Leitor',
                      description:
                      'Visualização apenas. Ideal para acompanhamento de tarefas sem permissão de alteração.',
                      color: const Color(0xFF7A8194),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget memberCard({
    required String image,
    required String name,
    required UserRole role,
  }) {
    IconData roleIcon = switch(role) {
      UserRole.owner => Icons.workspace_premium,
      UserRole.editor => Icons.edit_note,
      _ => Icons.remove_red_eye_outlined,
    };
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),

      child: Row(
        children: [

          Stack(
            children: [

              CircleAvatar(
                radius: 34,
                backgroundImage: NetworkImage(image),
              ),

              Positioned(
                bottom: 0,
                right: 0,

                child: Container(
                  width: 28,
                  height: 28,

                  decoration: BoxDecoration(
                    color: role.mainColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),

                  child: Icon(
                    roleIcon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: role.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    role.value,
                    style: TextStyle(
                      color: role.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),

          if(table.role == UserRole.owner)
            const Icon(
              Icons.edit_outlined,
              color: Color(0xFF7A8194),
            )
        ],
      ),
    );
  }

  static Widget accessItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          color: color,
          size: 32,
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF5E6472),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget bottomItem(IconData icon, String title, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color:
        selected ? const Color(0xFFE8EEF9) : Colors.transparent,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: selected
                ? const Color(0xFF244BCB)
                : const Color(0xFFA0A7B7),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF244BCB)
                  : const Color(0xFFA0A7B7),
            ),
          )
        ],
      ),
    );
  }
}