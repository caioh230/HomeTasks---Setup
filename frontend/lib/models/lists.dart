import 'package:flutter/material.dart';
import 'package:hometasks/widgets/board_card.dart';
import 'package:hometasks/widgets/task_card.dart';
import 'package:hometasks/widgets/notification_card.dart';
import 'package:hometasks/models/member.dart';

class Lists {
  static Map<String, Board> boards = {};
  static Map<String, Task> tasks = {};
  static Map<String, Member> users = {};
  static List<AppNotification> notifications = [];
  static void reloadBoards() async {
    boards.clear();
    // TO DO: Load boards from backend

    // PLACEHOLDER:
    boards["asdhuhawrihasr"] = Board(
      id: "asdhuhawrihasr",
      title: "Minha Casa",
      members: const [
        "125432315",
        "654123453",
        "365435754",
      ],
      role: UserRole.owner,
      isActive: true,
    );
    boards["greasodkwqeasd"] = Board(
      id: "greasodkwqeasd",
      title: "Apartamento República",
      members: const [
        "125432315",
        "654123453",
        "365435754",
        "986345122"
      ],
      role: UserRole.editor,
      isActive: true,
      icon: Icons.apartment_outlined,
    );
    boards["vpoxcjfdwermk"] = Board(
      id: "vpoxcjfdwermk",
      title: "Oficina do João",
      members: const [
        "125432315",
        "654123453",
      ],
      role: UserRole.reader,
      isActive: false,
      icon: Icons.home_work_outlined,
    );
  }
  
  static void reloadTasks({String? boardId}) async {
    tasks.clear();
    // TO DO: Load tasks from backend
    // Filter tasks with ID == boardId

    // placeholder
    tasks["asdaiwjekla"] = Task(
      id: "asdaiwjekla",
      title: "Limpar caixa do gato",
      description: "Trocar toda a areia e higienizar a base com desinfetante pet.",
      members: ["125432315"],
      board: "asdhuhawrihasr",
      priority: TaskPriority.high,
      expiration: DateTime.now().add(const Duration(hours: 6)),
      status: TaskStatus.notStarted,
    );
    tasks["grehlskdpo"] = Task(
      id: "grehlskdpo",
      title: "Compras da Semana",
      description: "Lista no bloco de notas da geladeira. Focar em frutas, carne e produtos de limpeza.",
      members: ["125432315", "654123453"],
      board: "greasodkwqeasd",
      expiration: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.notStarted,
    );
    tasks["qtriojhksda"] = Task(
      id: "qtriojhksda",
      title: "Organizar Home Office",
      description: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["125432315"],
      board: "asdhuhawrihasr",
      expiration: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.inProgress,
    );
    tasks["lfgdnmjhe"] = Task(
      id: "lfgdnmjhe",
      title: "Regar as Plantas",
      description: "Triagem de documentos e organização dos cabos embaixo da mesa.",
      members: ["125432315"],
      board: "greasodkwqeasd",
      expiration: DateTime.now().add(const Duration(hours: 3)),
      status: TaskStatus.inProgress,
    );
    tasks["gregfsdaz"] = Task(
      id: "gregfsdaz",
      title: "Lavar a louça do jantar",
      members: ["125432315"],
      board: "asdhuhawrihasr",
      expiration: DateTime.now().add(const Duration(hours: 8)),
      status: TaskStatus.complete,
      completedAt: DateTime.now().subtract(const Duration(hours: 2))
    );
  }

  static void reloadNotifications() async {
    notifications.clear();
    // TO DO: Load notifications from backend

    // PLACEHOLDER:
    notifications.add(
      AppNotification.taskInvite(Task(
        id: "awuieyu120qiwla",
        title: "Compras da semana",
        board: "greasodkwqeasd",
        members: [],
        expiration: DateTime.now().add(const Duration(hours: 2)),
      ),
      Member(
        id: "2",
        username: "Márcia",
      ),
      DateTime.now().subtract(const Duration(minutes: 20)))
    );
    
    notifications.add(
      AppNotification.taskExpiringIn(Task(
        id: "bvocjdfklg43091lm",
        title: "Limpar caixa do gato",
        board: "asdhuhawrihasr",
        members: [],
        expiration: DateTime.now().add(const Duration(hours: 2)),
      ),
      DateTime.now().subtract(const Duration(hours: 1)))
    );

    notifications.add(
      AppNotification.taskCompleted(Task(
        id: "bvocjdfklg43091lm",
        title: "Limpar caixa do gato",
        board: "asdhuhawrihasr",
        members: [],
        expiration: DateTime.now().add(const Duration(hours: 1)),
      ),
      Member(
        id: "1",
        username: "João Batista",
      ),
      DateTime.now().subtract(const Duration(days: 1)))
    );
    notifications.add(
      AppNotification.invitedToBoard(Board(
        id: "lsdfmklsdnfxcv",
        title: "Escritório Central",
        members: const [
          "315521531",
        ],
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
    users[id] = Member(id: id, username: "User $id");
    return users[id];
  }
}