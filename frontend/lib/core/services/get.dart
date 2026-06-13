import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:http/http.dart' as http;

class BackendGet {
  //Verificar em caso de erro
  static Future<http.Response> getPassword(
    String email,
    String code
  ) async {
    return http.get(
      Uri.parse('${Env.apiUrl}/ForgotPassword/email=${email}code=${code}'),
      headers: {
        'Content-Type': 'application/json',
      }
    );
  }

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
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to fetch table list: ${response.statusCode}');
      }
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
  static Future<http.Response> invitesPending() async {
    try {
      final token = await UserStorage.getToken();

      final response = await http.get(
        Uri.parse('${Env.apiUrl}/Relationship/invite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to fetch table list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch table list: $e');
    }
  }
}