import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/ForgotPassword/repositories/ForgotPasswordRepository.dart';
import 'package:hometasks/src/ForgotPassword/services/ForgotPasswordService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<ForgotPasswordService>(
    (_) => ForgotPasswordService(),
  );
}

Middleware repoProvider() {
  return provider<ForgotPasswordRepository>(
    (_) => ForgotPasswordRepository(),
  );
}
