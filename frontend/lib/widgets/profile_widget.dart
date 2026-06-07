import 'package:flutter/material.dart';
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/basic_button.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  void _signUserOut(context) async {
    await UserAccount.logout();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

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
                  Avatar(id: "1", size: 120),
                  const SizedBox(height: 16),
                  Text(
                    UserAccount.name ?? "Nome",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "@" + (UserAccount.username ?? "usuario"),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BasicButton(
                    onTap: () => _signUserOut(context),
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
}