import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';

///Importação de dados sensíveis
final env = DotEnv()..load();

///Conexão com o banco remoto
final app = FirebaseApp.initializeApp(
  options: AppOptions(
    credential: Credential.fromServiceAccount(
      File('database-credentials.json')
    ),
    projectId: env['projectId'],
  ),
);

///Execução de funções CRUD
final firestore = app.firestore();
