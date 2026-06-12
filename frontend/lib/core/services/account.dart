import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:hometasks/core/utils/lists.dart';
import 'package:http/http.dart' as http;

class UserAccount {
  static String? userId;
  static String? username;
  //static String? email;
  static String? name;

  /*********************
          LOGIN
  **********************/
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${Env.apiUrl}/User/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(switch(response.statusCode) {
        500 => "Credenciais incorretas",
        _ => response.body,
      });
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String;
    UserAccount.userId = json['id'] as String?;
    UserAccount.username = json['username'] as String?;
    //UserAccount.email = json['email'] as String?;
    UserAccount.name = json['name'] as String?;
    UserStorage.saveToken(token);
    return token;
  }

  /*********************
      LOGIN (GOOGLE)
  **********************/
  static final GoogleSignIn signIn = GoogleSignIn.instance;
  static Future<String> googleLogin() async {
    await signIn.initialize(
      serverClientId: Env.oauth2Id,
    );
    //print('Initialized.');

    final GoogleSignInAccount user = await signIn.authenticate();
    final authentication = user.authentication;
    //print('User selected: ${user.email}');

    final response = await http.post(
        Uri.parse('${Env.apiUrl}/User/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idToken': authentication.idToken,
        }),
      );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202) {
      throw Exception(switch(response.statusCode) {
        500 => "Credenciais incorretas",
        _ => response.body,
      });
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String;
    UserAccount.userId = json['id'] as String?;
    UserAccount.username = json['username'] as String?;
    //UserAccount.email = json['email'] as String?;
    UserAccount.name = json['name'] as String?;
    UserStorage.saveToken(token);
    return token;
  }

  /*********************
          REGISTER
  **********************/
  static Future<String> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${Env.apiUrl}/User'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
        'name': name,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(switch(response.statusCode) {
        500 => "Credenciais incorretas",
        _ => response.body,
      });
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String;
    UserAccount.userId = json['id'] as String?;
    UserAccount.username = json['username'] as String?;
    //UserAccount.email = json['email'] as String?;
    UserAccount.name = json['name'] as String?;
    UserStorage.saveToken(token);
    return token;
  }

  /*********************
          UPDATE
  **********************/
  //Verificar em caso de erro
  static Future<String> update({
    String? name,
    String? password,
  }) async {
    final body = <String, dynamic>{};

    if (name != null && name.trim().isNotEmpty) {
      body['name'] = name.trim();
    }

    if (password != null && password.trim().isNotEmpty) {
      body['password'] = password.trim();
    }

    final response = await http.put(
      Uri.parse('${Env.apiUrl}/User'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserStorage.getToken()}',
      },
      body: jsonEncode({
        body
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(switch(response.statusCode) {
        500 => "Credenciais incorretas",
        _ => response.body,
      });
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['token'] as String;
    UserAccount.userId = json['id'] as String?;
    UserAccount.username = json['username'] as String?;
    //UserAccount.email = json['email'] as String?;
    UserAccount.name = json['name'] as String?;
    UserStorage.saveToken(token);
    return token;
  }

  /*********************
          EXCLUSION
  **********************/
  //Verificar em caso de erro
  static Future<void> exclude(
  ) async {
    final response = await http.delete(
      Uri.parse('${Env.apiUrl}/User'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await UserStorage.getToken()}',
      }
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(switch(response.statusCode) {
        500 => "Credenciais incorretas",
        _ => response.body,
      });
    }    
  }
  
  /*********************
            JWT
  **********************/
  static Future<bool> jwtLogin(String jwt) async {
    if(jwt.isEmpty) {
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('${Env.apiUrl}/User'),
        headers: {
          'Login': 'true',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode != 200) {
        return false;
      }

      final json = jsonDecode(response.body);
      UserAccount.userId = json['id'] as String?;
      UserAccount.username = json['username'] as String?;
      //UserAccount.email = json['email'] as String?;
      UserAccount.name = json['name'] as String?;
      return true;
    } catch (_) {
      return false;
    }
  }

  /*********************
          LOGOUT
  **********************/
  static Future<void> logout() async {
    userId = username = name = /*email =*/ null;
    Lists.isTablesLoaded = Lists.isTasksLoaded = Lists.isNotifsLoaded = false;
    

    await UserStorage.deleteToken();
  }
}