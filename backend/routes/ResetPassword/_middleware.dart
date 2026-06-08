import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ResetPassword/repositories/ResetPasswordRepository.dart';
import 'package:hometasks/src/ResetPassword/services/ResetPasswordService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<ResetPasswordService>(
    (_) => ResetPasswordService(),
  );
}

Middleware repoProvider() {
  return provider<ResetPasswordRepository>(
    (_) => ResetPasswordRepository(),
  );
}
