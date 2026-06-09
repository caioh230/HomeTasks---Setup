import 'dart:convert';
import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/core/services/storage.dart';
import 'package:hometasks/core/utils/env.dart';
import 'package:hometasks/models/member.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/task.dart';
import 'package:http/http.dart' as http;

class BackendPost {
  static Future<http.Response> table({
    required String name,
    required String? description,
    required String icon,
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

  static Future<http.Response> task({
    required String idTable,
    required String name,
    required DateTime timeLimit,
    required TaskStatus status,
    required List<String> accountable,
    String? description,
    TaskPriority? priority,
  }) async {
    final token = await UserStorage.getToken();

    String taskStatus = switch(status) {
      TaskStatus.complete => 'complete',
      TaskStatus.inProgress => 'inProgress',
      _ => 'notStarted',
    };

    String? taskPriority = switch(priority) {
      TaskPriority.high => 'high',
      TaskPriority.medium => 'medium',
      TaskPriority.low => 'low',
      _ => null
    };

    return http.post(
      Uri.parse('${Env.apiUrl}/Task'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'idTable': idTable,
        'name': name,
        'description': description,
        'timeLimit': _formatTime(timeLimit),
        'taskStatus': taskStatus,
        'priority': taskPriority,
        'accountable': accountable,
        'criadoPor': UserAccount.userId,
        if(status == TaskStatus.complete)
          'completedAt': _formatTime(DateTime.now()),
        if(status == TaskStatus.complete)
          'completedBy': UserAccount.userId,
      }),
    );
  }

  static Future<http.Response> invitedToTable(
    Table table,
    String username,
    UserRole role,
  ) async {
    final token = await UserStorage.getToken();
    final userResponse = await http.get(
      Uri.parse('${Env.apiUrl}/User?username=$username'),
      headers: {
        'Login': 'false',
        'Authorization': 'Bearer $token',
      },
    );

    if (userResponse.statusCode != 200) {
      throw Exception('Usuário não encontrado.');
    }

    final userJson = jsonDecode(userResponse.body);
    final String idUser = userJson['id'] as String;
    print(idUser);

    String roleName = switch (role) {
      UserRole.editor => 'editor',
      _ => 'reader',
    };
    return http.post(
      Uri.parse('${Env.apiUrl}/Relationship'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'idTable':  table.id!,
        'idUser': idUser,
        'roleName': roleName,
        'tableName': table.title,
        'createdAt': _formatTime(DateTime.now()),
        'valid': false,
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