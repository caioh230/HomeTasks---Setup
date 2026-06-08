import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/get.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/notification.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/models/member.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Lists {
  static Map<String, Table> tables = {};
  static Map<String, Task> tasks = {};
  static List<AppNotification> notifications = [];

  static bool isTablesLoaded = false;
  static bool isTasksLoaded = false;
  static Future<void> reloadTables() async {
    tables.clear();
    isTablesLoaded = false;

    final list = jsonDecode((await BackendGet.tableList()).body);
    for (String id in list) {
      final http.Response response = await BackendGet.tableById(id);
      final Map<String, dynamic> body = jsonDecode(response.body);

      final Map<String, UserRole> members = {};
      for (final entry in Map<String, dynamic>.from(body['members'] ?? {}).entries) {
        members[entry.key] = switch (entry.value as String) {
          "owner" => UserRole.owner,
          "editor" => UserRole.editor,
          _ => UserRole.reader,
        };
      }

      tables[body['id']] = Table(
        id: body['id'],
        title: body['name'],
        members: members,
        icon: Table.getIconFromString(body['icon']),
        role: switch(body['roleName']) {
          'owner' => UserRole.owner,
          'editor' => UserRole.editor,
          _ => UserRole.reader,
        },
        isActive: body['isActive'] as bool,
      );
    }
    isTablesLoaded = true;
  }
  
  static Future<void> reloadTasks({String? boardId}) async {
    while (!isTablesLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    tasks.clear();
    isTasksLoaded = false;
    
    for (Table table in tables.values) {
      final list = jsonDecode((await BackendGet.tasksList(table.id!)).body);
      for(final obj in list) {
        TaskStatus status = switch(obj['taskStatus'] as String) {
          'complete' => TaskStatus.complete,
          'inProgress' => TaskStatus.inProgress,
          _ => TaskStatus.notStarted,
        };

        TaskPriority? priority = switch(obj['priority'] as String?) {
          'high' => TaskPriority.high,
          'medium' => TaskPriority.medium,
          'low' => TaskPriority.low,
          _ => null,
        };
        final expiration = DateTime.parse(obj['timeLimit']);
        final completedAt = (status == TaskStatus.inProgress ? (obj['completedAt'] != null ? DateTime.parse(obj['completedAt']) : expiration) : null);
        final accountable = List<String>.from(obj['accountable'] ?? []);
        final taskId = obj['id'] as String;
        tasks[taskId] = Task(
          id: taskId,
          title: obj['name'] as String,
          description: obj['description'] as String?,
          expiration: expiration,
          completedAt: completedAt,
          table: obj['idTable'] as String,
          priority: priority,
          status: status,
          accountable: accountable
        );
      }
    }
    isTasksLoaded = true;
  }

  static Future<void> reloadNotifications() async {
    notifications.clear();
    // TO DO: Load notifications from backend

    // PLACEHOLDER:
    notifications.add(
      AppNotification.taskInvite(Task(
        id: "awuieyu120qiwla",
        title: "Compras da semana",
        table: "greasodkwqeasd",
        accountable: [],
        expiration: DateTime.now().add(const Duration(hours: 2)),
      ),
      Member(
        id: "2",
        name: "Márcia",
        username: "marcia",
      ),
      DateTime.now().subtract(const Duration(minutes: 20)))
    );
    
    notifications.add(
      AppNotification.taskExpiringIn(Task(
        id: "bvocjdfklg43091lm",
        title: "Limpar caixa do gato",
        table: "asdhuhawrihasr",
        accountable: [],
        expiration: DateTime.now().add(const Duration(hours: 2)),
      ),
      DateTime.now().subtract(const Duration(hours: 1)))
    );

    notifications.add(
      AppNotification.taskCompleted(Task(
        id: "bvocjdfklg43091lm",
        title: "Limpar caixa do gato",
        table: "asdhuhawrihasr",
        accountable: [],
        expiration: DateTime.now().add(const Duration(hours: 1)),
      ),
      Member(
        id: "1",
        name: "João Batista",
        username: "joaobat"
      ),
      DateTime.now().subtract(const Duration(days: 1)))
    );
    notifications.add(
      AppNotification.invitedToTable(Table(
        id: "lsdfmklsdnfxcv",
        title: "Escritório Central",
        members: const {
          "315521531": UserRole.owner,
        },
        role: UserRole.reader,
        isActive: false,
        icon: Icons.home_work_outlined,
      ),
      DateTime.now().subtract(const Duration(days: 1)))
    );
  }
}