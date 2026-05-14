import 'package:flutter/material.dart';
import 'package:hometasks/routes/dashboard.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                'Configurações',
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