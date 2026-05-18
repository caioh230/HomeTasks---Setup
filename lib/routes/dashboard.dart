import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/widgets/basic_button.dart';

import 'package:hometasks/widgets/board_card.dart';
import 'screens/home.dart';
import 'screens/tasks.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';

class PageItem {
  final Widget page;
  final String title;

  const PageItem({
    required this.page,
    required this.title,
  });
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static final GlobalKey<DashboardPageState> globalKey =
    GlobalKey<DashboardPageState>();

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<PageItem> _pages = [
    PageItem(page: HomeScreen(), title: "Início"),
    PageItem(page: TasksScreen(), title: "Tarefas"),
    PageItem(page: ProfileScreen(), title: "Perfil"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      overlayPage = null;
      _selectedIndex = index;
    });
  }

  void openNotifications() async {

  }

  void openSettings() {
    showOverlay(SettingsScreen());
  }
  
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget? overlayPage;
  void showOverlay(Widget page) {
    setState(() {
      overlayPage = page;
    });
  }

  void closeOverlay() {
    setState(() {
      overlayPage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF),
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.black54,
              builder: (context) {
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
                          // X button
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                size: 24,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),

                              // Avatar
                              ClipOval(
                                child: Image.network(
                                  "https://i.pravatar.cc/100?img=1",
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Name
                              const Text(
                                "Nome de Usuário",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Email
                              Text(
                                user!.email!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Logout button
                              BasicButton(onTap: () {
                                signUserOut();
                                Navigator.pop(context);
                              },
                              text: "Sair da conta",
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: BoardCard.avatar(id: "1", size: 40),
        ),
        actions: [
          IconButton(
            onPressed: openNotifications,
            icon: const Icon(Icons.notifications_none),
            color: Color(0xFF64748B),
          ),
          IconButton(
            onPressed: openSettings,
            icon: const Icon(Icons.settings),
            color: Color(0xFF64748B),
          )
        ],
      ),
      body: Stack(
        children: [
          if (DashboardPage.globalKey.currentState?.overlayPage == null)
            IndexedStack(
              index: _selectedIndex,
              children: _pages.map((e) => e.page).toList(),
            ),
          if (DashboardPage.globalKey.currentState?.overlayPage != null)
            Container(
              color: Colors.white,
              child: DashboardPage.globalKey.currentState?.overlayPage!,
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Tarefas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
                
              ),
            ],
            selectedItemColor: Color(0xFF1E40AF),
            unselectedItemColor: Color(0xFF94A3B8),
          ),
        )
      )
    );
  }
}