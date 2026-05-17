import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Task/repositories/TaskRepository.dart';
import 'package:hometasks/src/Task/services/TaskService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<TaskRepository>(
    (_) => TaskRepository(),
  );
}

Middleware repoProvider() {
  return provider<TaskService>(
    (_) => TaskService(),
  );
}
