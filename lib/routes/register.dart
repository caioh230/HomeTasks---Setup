import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/basic_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
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
    if (passwordController.text != confirmPasswordController.text) {
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

    bool success = false;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
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
      })));
    } catch (e) {
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (success) {
        if(navigator.canPop()) navigator.pop();
        navigator.pushReplacementNamed('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 10),
                //welcome back you been missed

                const SizedBox(height: 25),

                //username
                BasicTextField(
                  controller: emailController,
                  hintText: 'Nome de usuário ou email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),
                //password
                BasicTextField(
                  controller: passwordController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                BasicTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar senha',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                //sign in button
                BasicButton(
                  onTap: signUserUp,
                  text: 'Cadastrar',
                ),
                const SizedBox(height: 20),

                // continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OU',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        'Já tenho uma conta.',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
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
