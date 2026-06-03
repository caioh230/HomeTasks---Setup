import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hometasks/widgets/basic_button.dart';

import 'package:hometasks/widgets/table_card.dart';
import 'package:hometasks/widgets/profile_widget.dart';
import 'screens/home.dart';
import 'screens/tasks.dart';
import 'screens/profile.dart';
import 'screens/notifications.dart';
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
    showOverlay(NotificationsScreen());
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
              builder: (context) => ProfileWidget(user: user!)
            );
          },
          child: TableCard.avatar(id: "1", size: 40),
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
          if (overlayPage == null)
            IndexedStack(
              index: _selectedIndex,
              children: _pages.map((e) => e.page).toList(),
            ),
          if (overlayPage != null)
            Container(
              color: Colors.white,
              child: overlayPage!,
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