import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/core/services/account.dart';
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
  Future<UserCredential?> signInWithGoogle() async {
    // TO DO: Test this
    try {
      await signIn.initialize();
      final GoogleSignInAccount user = await signIn.authenticate();
      final authentication = user.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );
      final logged = await FirebaseAuth.instance.signInWithCredential(credential); //verificar assinatura do google
      if(context.mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
      return logged;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return null;
    }
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
                              onForgotPassword: () => Navigator.pushReplacementNamed(context, '/forgot_password'),
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
