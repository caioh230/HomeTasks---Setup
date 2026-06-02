import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/User/repositories/UserRepository.dart';
import 'package:hometasks/src/User/services/UserService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<UserRepository>(
    (_) => UserRepository(),
  );
}

Middleware repoProvider() {
  return provider<UserService>(
    (_) => UserService(),
  );
}
