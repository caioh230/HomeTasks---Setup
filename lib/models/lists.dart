import 'package:flutter/material.dart';
import 'package:hometasks/widgets/board_card.dart';
import 'package:hometasks/widgets/task_card.dart';
import 'package:hometasks/models/member.dart';

class Lists {
  static List<Board> boards = [];
  static List<Task> tasks = [];
  static Map<String, Member> users = {};
  static void reloadBoards() async {
    boards.clear();
    // TO DO: Load boards from backend

    // PLACEHOLDER:
    boards.add(Board(
      id: "asdhuhawrihasr",
      title: "Minha Casa",
      members: const [
        "125432315",
        "654123453",
        "365435754",
      ],
      role: UserRole.owner,
      isActive: true,
    ));
    boards.add(Board(
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
    ));
    boards.add(Board(
      id: "vpoxcjfdwermk",
      title: "Oficina do João",
      members: const [
        "125432315",
        "654123453",
      ],
      role: UserRole.reader,
      isActive: false,
      icon: Icons.home_work_outlined,
    ));
  }
  
  static void reloadTasks(String boardID) async {
    tasks.clear();
    // TO DO: Load tasks from backend
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