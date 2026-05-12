import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';

final env = DotEnv()..load();

final app = FirebaseApp.initializeApp(
  options: AppOptions(
    credential: Credential.fromServiceAccount(
      File("database-credentials.json")
    ),
    projectId: env['projectId'],
  ),
);

final auth = app.auth();
final firestore = app.firestore();