import 'dart:convert';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendGet {
  static Future<http.Response> tableById(String id) async {
    try {
      final token = await UserStorage.getToken();

      final response = await http.get(
        Uri.parse('${Env.apiUrl}/Table/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch table by id: $e');
    }
  }
}