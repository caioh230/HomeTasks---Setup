import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/members_list.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/models/table.dart';

class InviteMemberScreen extends StatefulWidget {
  final Table table;
  const InviteMemberScreen({super.key, required this.table});

  @override
  State<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  final _emailController = TextEditingController();
  String _selectedRole = 'editor'; // Valor inicial selecionado

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose(); // CORREÇÃO 1: O correto é super.dispose()
  }

  void sendInvite() async {
    final email = _emailController.text;
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // TO DO
    // Trocar o "await Future.delayed" por uma
    // chamada de API para convidar novo usuário
    await Future.delayed(Duration(seconds: 1)); //placeholder
    //

    navigator.pop(); 
    DashboardPage.globalKey.currentState?.showOverlay(MembersListScreen(table: widget.table));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackButton(color: Color(0xFF1067B4), onPressed: () => DashboardPage.globalKey.currentState?.showOverlay(MembersListScreen(table: widget.table))),
                const SizedBox(width: 12),
                const Text(
                  'Convidar Membro',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 1. Card de Boas-Vindas (Topo)
            _buildHeaderCard(),
            const SizedBox(height: 30),

            // 2. Campo de E-mail
            const Text(
              'E-mail do novo membro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'exemplo@email.com',
                hintStyle: const TextStyle(color: Colors.black38),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black45),
                filled: true,
                fillColor: const Color(0xFFF4F5FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 28),

            // 3. Seleção de Papel (Role)
            const Text(
              'Papel no quadro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            _buildRoleOption(
              id: 'leitor',
              title: 'Leitor',
              subtitle: 'Pode apenas visualizar as tarefas',
              icon: Icons.visibility_outlined,
            ),
            const SizedBox(height: 12),
            _buildRoleOption(
              id: 'editor',
              title: 'Editor',
              subtitle: 'Pode criar, editar e concluir tarefas',
              icon: Icons.edit_square,
            ),
            const SizedBox(height: 12),
            _buildRoleOption(
              id: 'proprietario',
              title: 'Proprietário',
              subtitle: 'Controle total sobre o quadro e membros',
              icon: Icons.admin_panel_settings_outlined,
            ),
            const SizedBox(height: 40),

            BasicButton(
              onTap: sendInvite,
              text: "Enviar Convite",
              margin: EdgeInsetsGeometry.zero,
              padding: EdgeInsetsGeometry.all(20),
              suffixIcon: Icon(Icons.send_outlined, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE0EAF6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Text(
            'Traga mais\nharmonia para o lar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Convide pessoas para colaborarem na organização do seu espaço.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_outlined,
                  size: 50,
                  color: Color(0xFF0056B3),
                ),
              ),
              Positioned(
                right: 0,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD0E4FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    size: 18,
                    color: Color(0xFF0056B3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = id;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0056B3) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF475569)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedRole,
              activeColor: const Color(0xFF0056B3),
              onChanged: (String? value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}