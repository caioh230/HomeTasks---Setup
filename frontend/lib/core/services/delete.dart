import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendDelete {
  static Future<http.Response> relationship(String idTable) async {
    try {
      final token = await UserStorage.getToken();

      final response = await http.delete(
        Uri.parse('${Env.apiUrl}/Relationship/$idTable'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        return response;
      } else {
        throw Exception('Failed to delete relationship: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete relationship: $e');
    }
  }
}