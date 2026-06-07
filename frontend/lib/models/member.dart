import 'package:hometasks/models/table.dart';

class Member {
  String id;
  String name;
  String username;
  UserRole role;
  Member({
    required this.id,
    required this.name,
    required this.username,
    this.role = UserRole.reader,
  });
}