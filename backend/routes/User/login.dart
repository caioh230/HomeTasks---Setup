import 'package:dart_frog/dart_frog.dart';

import 'package:hometasks/src/User/models/UserModel.dart';
import 'package:hometasks/src/User/services/UserService.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
        statusCode: 405,
        body: 'Method not allowed',
      );
    }

    final service = context.read<UserService>();

    final data =
        await context.request.json() as Map<String, dynamic>;

    final user = UserModel.toModel(data, validateEmail: false);

    return await service.isUser(user, context);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: 'Login error: $e',
    );
  }
}