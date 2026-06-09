import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:hometasks/config/DataBase_client.dart';
import 'package:http/http.dart' as http;

final _env = DotEnv()..load();

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response(
        statusCode: 405,
        body: 'Method not allowed',
      );
    }

    final body = await context.request.json() as Map<String, dynamic>;

    final idToken = body['idToken'] as String?;

    if (idToken == null || idToken.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Missing idToken'},
      );
    }

    final response = await http.get(
      Uri.parse(
        'https://oauth2.googleapis.com/tokeninfo?id_token=$idToken',
      ),
    );

    if (response.statusCode != 200) {
      return Response.json(
        statusCode: 401,
        body: {'error': 'Invalid Google token'},
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;

    final googleId = payload['sub'] as String?;
    final email = payload['email'] as String?;
    final fullName = payload['name'] as String?;
    //final picture = payload['picture'] as String?;

    if (googleId == null || email == null) {
      return Response.json(
        statusCode: 401,
        body: {'error': 'Invalid Google account'},
      );
    }

    final usersRef = firestore.collection('User');

    final existing = await usersRef
        .where('googleId', WhereFilter.equal, googleId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final userData = doc.data() as Map<String, dynamic>;
      final token = _jwtToken({
        'id': doc.id,
        'googleId': userData['googleId'],
        'name': userData['name'],
        'username': userData['username'],
        'email': userData['email'],
      });

      return Response.json(
        body: {
          'token': token,
          'id': doc.id,
          'googleId': userData['googleId'],
          'name': userData['name'],
          'username': userData['username'],
          'email': userData['email'],
        },
      );
    }

    var baseUsername = email.split('@').first.toLowerCase();
    baseUsername = baseUsername.replaceAll(RegExp('[^a-z0-9]'), '');

    final username = await _generateUniqueUsername(usersRef, baseUsername);

    final newUserRef = await usersRef.add({
      'googleId': googleId,
      'name': fullName ?? 'Nome',
      'username': username,
      'email': email,
      'password': '', // google users don't use password
    });
    
    final token = _jwtToken({
      'googleId': googleId,
      'id': newUserRef.id,
      'name': fullName ?? 'Nome',
      'username': username,
      'email': email,
    });

    if (token.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: 'Erro ao gerar token',
      );
    }

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'token': token,
        'id': newUserRef.id,
        'googleId': googleId,
        'name': fullName,
        'username': username,
        'email': email,
        //'picture': picture,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'error': e.toString(),
      },
    );
  }
}

///Criar Tokens JWT
String _jwtToken(
  Map<String, dynamic> map
  ){
    try{
      final jwt = JWT(
        // Payload
        {
          'id': map['id'],
          'name': map['name'],
          'username': map['username'],
          'email': map['email'],
        },
        issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
      );

      // Sign it (default with HS256 algorithm)
      return jwt.sign(SecretKey(_env['jwtSecretKey'].toString()), expiresIn: const Duration(days: 30));
    }catch(e){
      return '';
    }
}

Future<String> _generateUniqueUsername(
  CollectionReference<Map<String, Object?>> usersRef,
  String baseUsername,
) async {
  var username = baseUsername;
  var counter = 1;
  while (true) {
    final result = await usersRef
        .where('username', WhereFilter.equal, username)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return username;
    }

    username = '$baseUsername$counter';
    counter++;
  }
}