import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Notification/repositories/NotificationRepository.dart';
import 'package:hometasks/src/Notification/services/NotificationService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<NotificationService>(
    (_) => NotificationService(),
  );
}

Middleware repoProvider() {
  return provider<NotificationRepository>(
    (_) => NotificationRepository(),
  );
}
