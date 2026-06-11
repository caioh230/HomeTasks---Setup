import 'package:flutter/material.dart';
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: UserAccount.name ?? "Meu Nome");
  //final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  @override
  void dispose() {
    _nameController.dispose();
    //_emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void openChangePicture() {
    // TO DO
  }

  //Verificar em caso de erro
  Future<void> saveChanges() async {
      if(
        _nameController.text.isEmpty
        &&
        _passwordController.text.isEmpty
        ){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Preencha os campos de edição.',
              ),
            ),
          );
      }else{
        final navigator = Navigator.of(context, rootNavigator: true);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        try{
          //Verificar em caso de erro
          await UserAccount.update(
            name: _nameController.text, 
            password:  _passwordController.text
          );

          navigator.pop(); 
          DashboardPage.globalKey.currentState?.closeOverlay();
        }catch(_){
          navigator.pop(); 

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro na alteração.',
              ),
            ),
          );
        }
      }
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
              // Cabeçalho
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: const Color(0xFF1067B4),
                    onPressed: DashboardPage.globalKey.currentState?.closeOverlay,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Editar perfil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Ícone
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Avatar(id: UserAccount.userId, size: 128, borderSize: 4),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: openChangePicture,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1067B4),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: openChangePicture,
                child: const Text(
                  'Alterar foto',
                  style: TextStyle(
                    color: Color(0xFF1067B4),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Inputs
              Container(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0, bottom: 40.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FB),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      label: 'Nome Completo',
                      controller: _nameController,
                    ),
                    //const SizedBox(height: 20),
                    //InputField(label: 'Email', controller: _emailController),
                    const SizedBox(height: 20),
                    InputField(label: 'Trocar senha', controller: _passwordController, isPassword: true),
                    const SizedBox(height: 20),
                    InputField(label: 'Confirmar nova senha', controller: _confirmPasswordController, isPassword: true),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              //Botões
              BasicButton(
                text: 'Salvar Alterações',
                //Verificar em caso de erro
                onTap: saveChanges,
                margin: EdgeInsets.zero,
                textSize: 18,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: DashboardPage.globalKey.currentState?.closeOverlay,
                child: Text(
                  'Descartar Alterações',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}