import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Table/repositories/TableRepository.dart';
import 'package:hometasks/src/Table/services/TableService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<TableRepository>(
    (_) => TableRepository(),
  );
}

Middleware repoProvider() {
  return provider<TableService>(
    (_) => TableService(),
  );
}
