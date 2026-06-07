import 'package:flutter/material.dart';
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/core/services/storage.dart';

import 'dashboard.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> _checkLogin() async {
    final jwt = await UserStorage.getToken();
    if (jwt == null || jwt.isEmpty) {
      return false;
    }

    return await UserAccount.jwtLogin(jwt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == true) {
            return DashboardPage(
              key: DashboardPage.globalKey,
            );
          }

          return LoginPage();
        },
      ),
    );
  }
}
