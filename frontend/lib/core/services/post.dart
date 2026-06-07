import 'dart:convert';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendPost {
  static Future<http.Response> table({required String name, required String? description, required int icon}) async {
    return await http.post(
      Uri.parse('${Env.apiUrl}/Table'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'icon': icon,
      }),
    );
  }
}