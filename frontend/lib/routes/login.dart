//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/core/services/get.dart';
import 'package:hometasks/core/services/post.dart';
import 'package:hometasks/core/utils/env.dart';

import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/input_field.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signUserIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if(email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o campo de e-mail e tente novamente.")),
      );
      return;
    }
    if(password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o campo de senha e tente novamente.")),
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
      /*await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      success = true;*/

      await UserAccount.login(
        email: email,
        password: password,
      );
      navigator.pop();
      Navigator.pushReplacementNamed(context, '/dashboard');
    } /*on FirebaseAuthException catch (e) {
      navigator.pop(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(switch(e.code) {
          'invalid-email' => 'E-mail inválido!',
          'invalid-credential' => 'Senha ou e-mail estão incorretas.',
          _ => e.code
        })),
      );
    }*/ catch (e) {
      navigator.pop(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } /*finally {
      if (success && navigator.canPop()) {
        navigator.pop();
      }
      if(context.mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }*/
  }

  final GoogleSignIn signIn = GoogleSignIn.instance;
  void signInWithGoogle() async {
    //print('Initializing Google Sign-In...');
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await UserAccount.googleLogin();
      navigator.pop();
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      navigator.pop(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Verificar em caso de erro
    String _email = '';

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
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bem-vindo(a)!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Organize a sua rotina doméstica com serenidade e ordem.',
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
                              label: 'Nome de usuário ou E-mail',
                              controller: _emailController,
                              backgroundColor:
                              Color(0xFFF2F3FB),
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
                              //Verificar em caso de erro
                              onForgotPassword: () async {
                                bool emailEnviadoComSucesso = false;

                                await showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) { 
                                    return AlertDialog(
                                      title: const Text('Recuperação de senha'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Insira o seu email'),
                                          const SizedBox(height: 20),
                                          TextField(
                                            decoration: const InputDecoration(
                                              labelText: 'E-mail',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (valor) {
                                              _email = valor;
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        // Botão Sair
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text('Sair'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_email.isNotEmpty) {
                                              await BackendPost.getPasswordCode(_email);
                                              
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('E-mail enviado, verifique seu código'),
                                                ),
                                              );

                                              emailEnviadoComSucesso = true;
                                              Navigator.pop(dialogContext); 
                                            } else {
                                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Campo de email vazio, preencha-o antes de enviar'),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Confirmar'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (emailEnviadoComSucesso) {
                                  String _codigoVerificacao = '';

                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext secondDialogContext) {
                                      return AlertDialog(
                                        title: const Text('Verificação de Código'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Insira o código enviado para o seu e-mail:'),
                                            const SizedBox(height: 20),
                                            TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Código de Verificação',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (valor) {
                                                _codigoVerificacao = valor;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(secondDialogContext);
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (_codigoVerificacao.isNotEmpty) {
                                                final password = await BackendGet.getPassword(_email, _codigoVerificacao);

                                                if (
                                                  context.mounted
                                                  &&
                                                  password.statusCode == 202
                                                ) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Sua senha é: ${jsonDecode(password.body)}'),
                                                    ),
                                                  );
                                                }else{
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Erro ${password.statusCode} na requisição'),
                                                    ),
                                                  );
                                                }
                                                
                                                Navigator.pop(secondDialogContext);
                                              }
                                            },
                                            child: const Text('Verificar Código'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              hintText: "Senha1234*",
                            ),
                            const SizedBox(height: 35),
                            BasicButton(
                              margin: EdgeInsetsGeometry.zero,
                              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                              onTap: signUserIn,
                              text: 'Entrar',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
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
                            BasicButton(
                              margin: EdgeInsetsGeometry.zero,
                              padding: EdgeInsetsGeometry.symmetric(vertical: 6),
                              onTap: signInWithGoogle,
                              text: 'Entrar com Google',
                              prefixIcon: SvgPicture.asset('assets/images/google.svg', width: 40, height: 40),
                            ),
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
                      'Ainda não faz parte? ',
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                      child: Text(
                        "Criar nova conta.",
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
