import 'package:flutter/material.dart';
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUserUp() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if(email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o campo de nome completo e tente novamente.')),
      );
      return;
    }
    if(email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o campo do nome de usuário e tente novamente.')),
      );
      return;
    }
    if(email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o campo de e-mail e tente novamente.')),
      );
      return;
    }
    if(password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o campo de senha e tente novamente.')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    //bool success = false;
    try {
      /*await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      success = true;
    } on FirebaseAuthException catch (e) {
      navigator.pop(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(switch(e.code) {
        'invalid-email' => 'E-mail inválido!',
        'invalid-credential' => 'Senha ou e-mail estão incorretas.',
        'weak-password' => 'Senha fraca!\nDeixe-a mais forte adicionando caracteres especiais, números e letras maiúsculas.',
        'email-already-in-use' => 'Esse e-mail já está sendo usado por outra conta.',
        _ => e.code
      })));*/

      await UserAccount.register(
        name: name,
        username: username,
        email: email,
        password: password,
      );
      navigator.pop();
      if(context.mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } /*finally {
      if (success) {
        if(navigator.canPop()) {
          navigator.pop();
        }
        if(context.mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F3FB),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xFF1067B4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.house_outlined,
                    size: 35,
                    color: Colors.white,
                  ),

                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Criar sua conta",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Comece sua jornada para um lar mais organizado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0, bottom: 40.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              label: 'Nome completo',
                              controller: _nameController,
                              hintText: "Digite seu nome",
                              backgroundColor: Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              label: 'Nome de usuário',
                              controller: _usernameController,
                              backgroundColor: Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.mail_outline),
                              hintText: "@nomeusuario",
                              onChanged: (String str) {
                                str = str.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
                                if(str.isNotEmpty) _usernameController.text = "@${str}";
                                else _usernameController.text = "";
                              },
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              label: 'E-mail',
                              controller: _emailController,
                              backgroundColor: Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.mail_outline),
                              hintText: "nome@exemplo.com",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              label: 'Senha',
                              controller: _passwordController,
                              isPassword: true,
                              backgroundColor: Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.lock_outline),
                              hintText: "Senha1234*",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              label: 'Confirmar senha',
                              controller: _confirmPasswordController,
                              isPassword: true,
                              backgroundColor: Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.lock_outline),
                              hintText: "Senha1234*",
                            ),
                            const SizedBox(height: 35),
                            BasicButton(
                              margin: EdgeInsetsGeometry.zero,
                              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                              onTap: signUserUp,
                              text: 'Criar conta',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta? ',
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        "Entrar.",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
