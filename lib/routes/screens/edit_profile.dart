import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controladores de texto
  final _nameController = TextEditingController(text: 'Márcia Almeida Costa');
  final _emailController = TextEditingController(text: 'marcia@exemplo.com');
  final _passwordController = TextEditingController(text: 'marcia@exemplo.com');
  final _confirmPasswordController = TextEditingController(text: 'marcia@exemplo.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                
                // --- CABEÇALHO (SETA + TÍTULO IGUAL AO PRINT) ---
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFF1067B4),
                      onPressed: () => DashboardPage.globalKey.currentState?.closeOverlay(),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Editar perfil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B), // Tom escuro suave para o título
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // --- FOTO DE PERFIL (AVATAR) ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400'),
                        ),
                      ),
                      // Lápis azul de edição sobreposto
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () {
                            // Lógica para alterar foto
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1067B4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Link "Alterar foto"
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Alterar foto',
                    style: TextStyle(
                      color: Color(0xFF1067B4),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- CARTÃO DO FORMULÁRIO (CAMPOS) ---
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(label: 'Nome Completo', controller: _nameController),
                      const SizedBox(height: 16),
                      _buildInputField(label: 'Email', controller: _emailController),
                      const SizedBox(height: 16),
                      _buildInputField(label: 'Senha', controller: _passwordController, isPassword: true),
                      const SizedBox(height: 16),
                      _buildInputField(label: 'Confirmar senha', controller: _confirmPasswordController, isPassword: true),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // --- BOTÕES DE AÇÃO ---
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para salvar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1067B4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: () => DashboardPage.globalKey.currentState?.closeOverlay(),
                  child: Text(
                    'Descartar alterações',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função auxiliar para gerar os campos de texto do formulário
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}