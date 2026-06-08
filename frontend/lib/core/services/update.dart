import 'dart:convert';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:hometasks/models/task.dart';
import 'package:http/http.dart' as http;

class BackendUpdate {
  static Future<http.Response> editTable({
    required String id,
    required String name,
    required String? description,
    required String icon,
    required bool isActive,
  }) async {
    final token = await UserStorage.getToken();

    return http.put(
      Uri.parse('${Env.apiUrl}/Table/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description ?? "",
        'icon': icon,
        'isActive': isActive,
      }),
    );
  }
  
  static Future<http.Response> editTask({
    required String id,
    required String name,
    required String? description,
    required String icon,
    required bool isActive,
  }) async {
    final token = await UserStorage.getToken();

    return http.patch(
      Uri.parse('${Env.apiUrl}/Table/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description ?? '',
        'icon': icon,
        'isActive': isActive,
      }),
    );
  }
  
  static Future<http.Response> setTaskStatus({
    required String id,
    required TaskStatus status,
    DateTime? completedAt,
  }) async {
    final token = await UserStorage.getToken();

    String taskStatus = switch(status) {
      TaskStatus.complete => 'complete',
      TaskStatus.inProgress => 'notStarted',
      _ => 'notStarted',
    };

    return http.patch(
      Uri.parse('${Env.apiUrl}/Task/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'taskStatus': taskStatus,
        if(completedAt != null)
          'completedAt': _formatTime(completedAt)
      }),
    );
  }

  static String _formatTime(DateTime date) {
    final utc = date.toUtc();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${utc.year}-'
        '${twoDigits(utc.month)}-'
        '${twoDigits(utc.day)}T'
        '${twoDigits(utc.hour)}:'
        '${twoDigits(utc.minute)}:'
        '${twoDigits(utc.second)}Z';
  }
}