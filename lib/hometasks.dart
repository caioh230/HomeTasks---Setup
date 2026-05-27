///Documentação central do sistema
library hometasks;

///Arquivos para Column
export 'src/Column/models/ColumnDBModel.dart';
export 'src/Column/models/ColumnModel.dart';
export 'src/Column/repositories/ColumnRepository.dart';
export 'src/Column/services/ColumnService.dart';

///Arquivos para Table
export 'src/Table/models/TableDBModel.dart';
export 'src/Table/models/TableModel.dart';
export 'src/Table/repositories/TableRepository.dart';
export 'src/Table/services/TableService.dart';


///Arquivos para Task
export 'src/Task/models/TaskDBModel.dart';
export 'src/Task/models/TaskModel.dart';
export 'src/Task/repositories/TaskRepository.dart';
export 'src/Task/services/TaskService.dart';


///Arquivos para User
export 'src/User/models/UserDBModel.dart';
export 'src/User/models/UserModel.dart';
export 'src/User/repositories/UserRepository.dart';
export 'src/User/services/UserService.dart';


import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/config/observability.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  await Observability.initialize();
  return serve(handler, ip, port);
}