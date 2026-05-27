import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:hometasks/config/observability.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  await Observability.initialize();
  return serve(handler, ip, port);
}