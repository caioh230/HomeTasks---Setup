import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/Relationship/repositories/RelationshipRepository.dart';
import 'package:hometasks/src/Relationship/services/RelationshipService.dart';

Handler middleware(Handler handler) {
    return handler
      .use(requestLogger())
      .use(repoProvider())
      .use(serviceProvider());
}


Middleware serviceProvider() {
  return provider<RelationshipService>(
    (_) => RelationshipService(),
  );
}

Middleware repoProvider() {
  return provider<RelationshipRepository>(
    (_) => RelationshipRepository(),
  );
}
