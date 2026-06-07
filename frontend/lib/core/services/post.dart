import 'dart:convert';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendPost {
  static Future<http.Response> table({
    required String name,
    required String? description,
    required int icon,
  }) async {
    final token = await UserStorage.getToken();

    return http.post(
      Uri.parse('${Env.apiUrl}/Table'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description ?? "",
        'icon': icon,
        'isActive': true,
      }),
    );
  }
}