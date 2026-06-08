import 'dart:convert';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendGet {
  static Future<http.Response> tableList() async {
    try {
      final token = await UserStorage.getToken();

      final response = await http.get(
        Uri.parse('${Env.apiUrl}/Relationship'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      return response;
    } catch (e) {
      throw Exception('Failed to fetch table list: $e');
    }
  }

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
  
  static Future<http.Response> tasksList(String idTable) async {
    try {
      final token = await UserStorage.getToken();

      final response = await http.get(
        Uri.parse('${Env.apiUrl}/Task?idTable=${idTable}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      return response;
    } catch (e) {
      throw Exception('Failed to fetch table list: $e');
    }
  }
}