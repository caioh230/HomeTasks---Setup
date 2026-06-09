import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl => dotenv.get('API_URL', fallback: 'http://localhost:8080');
  static String get oauth2Id => dotenv.get('OAUTH2_ID', fallback: 'xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com');
}
