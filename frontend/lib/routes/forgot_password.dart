//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/widgets/basic_button.dart';
import 'package:hometasks/widgets/input_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void confirmEmailSend() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha o campo de e-mail e tente novamente.',
          ),
        ),
      );
      return;
    }

    final navigator = Navigator.of(
      context,
      rootNavigator: true,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator()),
    );

    /*bool success = false;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      success = true;
    } on FirebaseAuthException catch (e) {
      if (navigator.canPop()) {
        navigator.pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            switch (e.code) {
              'invalid-email' => 'E-mail inválido!',
              'user-not-found' => 'Nenhuma conta encontrada com esse e-mail.',
              _ => e.message ?? e.code,
            },
          ),
        ),
      );
    }
    catch (e) {
        if (navigator.canPop()) {
          navigator.pop();
        }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    finally {
      if (success) {
        if (navigator.canPop()) {
          navigator.pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se o e-mail estiver cadastrado, você receberá um link de recuperação.\nOlhe sua caixa de entrada ou spam.',
            ),
          ),
        );
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF1067B4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_outlined,
                    size: 50,
                    color: Colors.white,
                  ),

                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Recuperar senha",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Insira seu e-mail para receber as instruções de recuperação.',
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
                              label: 'E-mail da conta',
                              controller: _emailController,
                              backgroundColor:
                              Color(0xFFF2F3FB),
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            const SizedBox(height: 35),
                            BasicButton(
                              margin: EdgeInsetsGeometry.zero,
                              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                              onTap: confirmEmailSend,
                              text: 'Enviar Link de Recuperação',
                              suffixIcon: Icon(Icons.send_outlined, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Colors.blue[900],
                      ),
                      Text(
                        " Voltar para a tela de login",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
