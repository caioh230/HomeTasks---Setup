import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              BackButton(color: Color(0xFF1067B4), onPressed: () => DashboardPage.globalKey.currentState?.closeOverlay()),
              const SizedBox(width: 12),
              const Text(
                'Editar Perfil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}