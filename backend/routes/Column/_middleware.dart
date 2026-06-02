import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Column/repositories/ColumnRepository.dart';
import 'package:hometasks/src/Column/services/ColumnService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<ColumnRepository>(
    (_) => ColumnRepository(),
  );
}

Middleware repoProvider() {
  return provider<ColumnService>(
    (_) => ColumnService(),
  );
}
