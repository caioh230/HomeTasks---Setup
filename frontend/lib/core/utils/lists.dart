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
  static bool isNotifsLoaded = false;
  static Future<void> reloadTables() async {
    tables.clear();
    isTablesLoaded = false;

    final list = jsonDecode((await BackendGet.tableList()).body);
    for (String id in list) {
      final http.Response response = await BackendGet.tableById(id);
      final Map<String, dynamic> body = jsonDecode(response.body);

      final Map<String, Member> members = {};
      for (final entry in Map<String, dynamic>.from(body['members'] ?? {}).entries) {
        members[entry.key] = Member(
          id: entry.key,
          name: entry.value['name'] as String? ?? "Nome",
          username: entry.value['username'] as String? ?? "username",
          role: switch (entry.value['roleName'] as String?) {
            "owner" => UserRole.owner,
            "editor" => UserRole.editor,
            _ => UserRole.reader,
          }
        );
      }

      tables[body['id']] = Table(
        id: body['id'],
        title: body['name'],
        description: body['description'],
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
        final completedAt = (status == TaskStatus.complete ? (obj['completedAt'] != null ? DateTime.parse(obj['completedAt']) : expiration) : null);
        final completedBy = (status == TaskStatus.complete ? (obj['completedBy'] as String) : null);
        final accountable = List<String>.from(obj['accountable'] ?? []);
        final taskId = obj['id'] as String;
        tasks[taskId] = Task(
          id: taskId,
          title: obj['name'] as String,
          description: obj['description'] as String?,
          expiration: expiration,
          completedAt: completedAt,
          completedBy: completedBy,
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
    while (!isTablesLoaded || !isTasksLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    notifications.clear();
    isNotifsLoaded = false;
    for (Task task in tasks.values) {
      if(task.status == TaskStatus.complete) {
        notifications.add(
          AppNotification.taskCompleted(
            task,
            task.completedBy!,
            task.completedAt!
          ));
      } else {
        final timeToExpire = task.expiration.difference(DateTime.now());
        if (timeToExpire > Duration.zero && timeToExpire < const Duration(hours: 2)) {
          notifications.add(
            AppNotification.taskExpiringIn(
              task,
              task.expiration,
            ),
          );
        }
      }
    }

    final response = await BackendGet.invitesPending();
    final List<dynamic> data = jsonDecode(response.body);
    for (var obj in data) {
      //final idRelation = obj["id"] as String;
      final idTable = obj["idTable"] as String;
      final tableName = obj["tableName"] as String;
      final createdAt = DateTime.tryParse((obj["createdAt"] as String?) ?? "") ?? DateTime.now();
      notifications.add(
        AppNotification.invitedToTable(
          idTable,
          Table(
            id: idTable,
            title: tableName,
            members: const {},
            role: UserRole.reader,
            isActive: true,
            icon: Icons.home_work_outlined,
          ),
          createdAt
        )
      );
    }

    // PLACEHOLDER:
    /*notifications.add(
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
    );*/

    notifications.sort((a, b) {
      final aHasTask = a.task != null;
      final bHasTask = b.task != null;

      // Notificações com task primeiro
      if (aHasTask && !bHasTask) return -1;
      if (!aHasTask && bHasTask) return 1;

      // Ambas têm task: ordenar por expiração
      if (aHasTask && bHasTask) {
        return a.task!.expiration.compareTo(
          b.task!.expiration,
        );
      }

      // Fallback: mais recentes primeiro
      return b.time.compareTo(a.time);
    });
    isNotifsLoaded = true;
  }
}