import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hometasks/widgets/basic_button.dart';

class ProfileWidget extends StatefulWidget {
  final User user;
  const ProfileWidget({
    super.key,
    required this.user,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _closePressed = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onHighlightChanged: (value) {
                    setState(() {
                      _closePressed = value;
                    });
                  },
                  onTap: () => Navigator.pop(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: _closePressed ? Colors.black.withValues(alpha: 0.2) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    width: 30,
                    height: 30,
                    child: const Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  ClipOval(
                    child: Image.network(
                      "https://i.pravatar.cc/100?img=1",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Nome de Usuário",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.user.email!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BasicButton(
                    onTap: () => signUserOut(context),
                    text: "Sair da conta",
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUserOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}