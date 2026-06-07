import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/core/services/get.dart';
import 'package:hometasks/models/table.dart';
import 'package:hometasks/models/notification.dart';
import 'package:hometasks/models/task.dart';
import 'package:hometasks/models/member.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Lists {
  static Map<String, Table> boards = {};
  static Map<String, Task> tasks = {};
  static Map<String, Member> users = {};
  static List<AppNotification> notifications = [];

  static bool isTablesLoaded = false;
  static bool isTasksLoaded = false;
  static Future<void> reloadTables() async {
    boards.clear();
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

      boards[body['id']] = Table(
        id: body['id'],
        title: body['name'],
        members: members,
        icon: Table.getIconFromString(body['icon']),
        role: switch(body['roleName']) {
          'owner' => UserRole.owner,
          'editor' => UserRole.editor,
          _ => UserRole.reader,
        },
        isActive: true,
      );
    }
    isTablesLoaded = false;
  }
  
  static Future<void> reloadTasks({String? boardId}) async {
    tasks.clear();
    // TO DO: Load tasks from backend
    // Filter tasks with ID == boardId

    // placeholder
    tasks["asdaiwjekla"] = Task(
      id: "asdaiwjekla",
      title: "Limpar caixa do gato",
      description: "Trocar toda a areia e higienizar a base com desinfetante pet.",
      members: ["125432315"],
      table: "asdhuhawrihasr",
      priority: TaskPriority.high,
      expiration: DateTime.now().add(const Duration(hours: 6)),
      status: TaskStatus.notStarted,
    );
    tasks["grehlskdpo"] = Task(
      id: "grehlskdpo",
      title: "Compras da Semana",
      description: "Lista no bloco de notas da geladeira. Focar em frutas, carne e produtos de limpeza.",
      members: ["125432315", "654123453"],
      table: "greasodkwqeasd",
      expiration: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.notStarted,
    );
    tasks["qtriojhksda"] = Task(
      id: "qtriojhksda",
      title: "Organizar Home Office",
      description: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["125432315"],
      table: "asdhuhawrihasr",
      expiration: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.inProgress,
    );
    tasks["lfgdnmjhe"] = Task(
      id: "lfgdnmjhe",
      title: "Regar as Plantas",
      description: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["125432315"],
      table: "greasodkwqeasd",
      expiration: DateTime.now().add(const Duration(hours: 3)),
      status: TaskStatus.inProgress,
    );
    tasks["gregfsdaz"] = Task(
      id: "gregfsdaz",
      title: "Lavar a louça do jantar",
      members: ["125432315"],
      table: "asdhuhawrihasr",
      expiration: DateTime.now().add(const Duration(hours: 8)),
      status: TaskStatus.complete,
      completedAt: DateTime.now().subtract(const Duration(hours: 2))
    );
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
        members: [],
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
        members: [],
        expiration: DateTime.now().add(const Duration(hours: 2)),
      ),
      DateTime.now().subtract(const Duration(hours: 1)))
    );

    notifications.add(
      AppNotification.taskCompleted(Task(
        id: "bvocjdfklg43091lm",
        title: "Limpar caixa do gato",
        table: "asdhuhawrihasr",
        members: [],
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

  static Member? loadMember(String id) {
    if(users[id] != null) {
      return users[id];
    }
    
    // TO DO: Get user name from API
    users[id] = Member(id: id, name: "Carregando...", username: "usuario");
    return users[id];
  }
}