import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:hometasks/config/observability.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  await Observability.initialize(env);
  return serve(handler, ip, port);
}