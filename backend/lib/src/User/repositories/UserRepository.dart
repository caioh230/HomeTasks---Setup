import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:logging/logging.dart';

import 'package:hometasks/config/DataBase_client.dart';

import 'package:hometasks/src/User/models/UserDBModel.dart';
import 'package:hometasks/src/User/models/UserGetModel.dart';
import 'package:hometasks/src/User/models/UserModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Responsável pela conexão com o banco remoto
class UserRepository {
  static final _log = Logger('UserRepository');

  ///Referência à coleção User
  final ref = firestore.collection('User');

  //-----------------------------
  //            create - Cadastro
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createUser(UserModel user) async {
    _log.info({
      'event': 'create_user_requested',
      'email': user.email,
      'username': user.username,
    }.toString());

    if (
      user.email.isEmpty ||
      user.password.isEmpty ||
      (user.username?.isEmpty ?? true) ||
      (user.name?.isEmpty ?? true)
    ) {
      _log.warning({
        'event': 'create_user_invalid_payload',
        'email': user.email,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Faltam campos para cadastrar o usuário',
      );
    }

    try {
      final emailResult = await ref
          .where(
            'email',
            WhereFilter.equal,
            user.email,
          )
          .get();

      if (!emailResult.empty) {
        _log.warning({
          'event': 'create_user_email_already_exists',
          'email': user.email,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: 'Email já cadastrado no sistema',
        );
      }

      final usernameResult = await ref
          .where(
            'username',
            WhereFilter.equal,
            user.username!,
          )
          .get();

      if (!usernameResult.empty) {
        _log.warning({
          'event': 'create_user_username_already_exists',
          'username': user.username,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.conflict,
          body: 'Nome de usuário já está em uso',
        );
      }

      final refDoc = ref.doc();

      final data = {
        ...user.toMap(),
        'id': refDoc.id,
      };

      await refDoc.set(data);

      final token = _jwtToken(data);

      _log.info({
        'event': 'user_created',
        'user_id': refDoc.id,
        'email': user.email,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.created,
        body: {
          'token': token,
          'id': refDoc.id,
          'name': user.name!,
          'username': user.username!,
          'email': user.email,
        },
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'create_user_failed',
          'email': user.email,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Obter instância já registrada no banco remoto
  Future<Response> readUser(
    RequestContext context,
  ) async {
    try {
      final id = await _validateOpr(context);

      _log.info({
        'event': 'read_user_requested',
        'user_id': id,
      }.toString());

      final val = await ref
          .doc(id)
          .get();

      final formDados = UserDBModel.fromFirestore(val);

      _log.info({
        'event': 'user_found',
        'user_id': id,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.found,
        body: formDados.toMap(),
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_user_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            read - Login
  //-----------------------------
  ///Verificar se uma instância existe no banco remoto e retorna um JWT
  Future<Response> isUser(UserModel user) async {
    try {
      final identifier = user.email;

      _log.info({
        'event': 'login_requested',
        'identifier': identifier,
      }.toString());

      var val = await ref
          .where('email', WhereFilter.equal, identifier)
          .where('password', WhereFilter.equal, user.password)
          .get();

      if (
        val.empty &&
        (identifier.startsWith('@') || !identifier.contains('@'))
      ) {
        val = await ref
            .where('username', WhereFilter.equal, identifier)
            .where('password', WhereFilter.equal, user.password)
            .get();
      }

      if (val.empty) {
        _log.warning({
          'event': 'login_failed',
          'identifier': identifier,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'E-mail ou senha inválidos',
        );
      }

      final doc = val.docs.first;
      final data = UserDBModel.fromFirestore(doc).toMap();
      if (data['googleId'] != null && (data['googleId'] as String).isNotEmpty) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: 'Este usuário faz login com Google. Use "Entrar com Google".',
        );
      }

      final token = _jwtToken({
        'id': data['id'],
        'name': data['name'],
        'username': data['username'],
        'email': data['email'],
      });

      if (token.isEmpty) {
        _log.severe({
          'event': 'jwt_generation_failed',
          'user_id': data['id'],
        }.toString());

        return Response.json(
          statusCode: HttpStatus.internalServerError,
          body: 'Erro ao gerar token',
        );
      }

      _log.info({
        'event': 'login_success',
        'user_id': data['id'],
      }.toString());

      return Response.json(
        statusCode: HttpStatus.ok,
        body: {
          'token': token,
          'id': data['id'],
          'name': data['name'],
          'username': data['username'],
          'email': data['email'],
        },
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'login_internal_error',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: 'Erro interno: $e',
      );
    }
  }

  //-----------------------------
  //            read - Login (Token)
  //-----------------------------
  ///Verificar se uma instância existe com um certo token
  Future<Response> isUserByToken(
    String token,
  ) async {
    try {
      _log.info({
        'event': 'token_auth_requested',
      }.toString());

      final payload = _verifyJwtToken(token);

      if (payload == null || !payload.containsKey('id')) {
        _log.warning({
          'event': 'token_invalid',
        }.toString());

        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: 'Token inválido',
        );
      }

      final userId = payload['id'].toString();

      final user = await readUserById(userId);

      if (user == null) {
        _log.warning({
          'event': 'token_auth_user_not_found',
          'user_id': userId,
        }.toString());

        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'Usuário não encontrado',
        );
      }

      _log.info({
        'event': 'token_auth_success',
        'user_id': userId,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.ok,
        body: {
          'id': user.id,
          'name': user.name,
          'username': user.username,
          'email': user.email,
        },
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'token_auth_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: 'Falha ao autenticar por token: $e',
      );
    }
  }

  Map<String, dynamic>? _verifyJwtToken(String token) {
    try {
      final jwt = JWT.verify(
        token,
        SecretKey(_env['jwtSecretKey'].toString()),
      );

      return jwt.payload as Map<String, dynamic>;
    } catch (_) {
      _log.warning({
        'event': 'jwt_verification_failed',
      }.toString());

      return null;
    }
  }

  //-----------------------------
  //            read - User by id
  //-----------------------------
  ///Pega dados do usuário pelo firebase através de um ID de usuário
  Future<UserDBModel?> readUserById(String id) async {
    try {
      _log.info({
        'event': 'read_user_by_id_requested',
        'user_id': id,
      }.toString());

      final doc = await ref.doc(id).get();

      if (!doc.exists) {
        _log.warning({
          'event': 'user_not_found',
          'user_id': id,
        }.toString());

        return null;
      }

      _log.info({
        'event': 'user_found_by_id',
        'user_id': id,
      }.toString());

      return UserDBModel.fromFirestore(doc);
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'read_user_by_id_failed',
          'user_id': id,
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      throw Exception('Erro ao buscar usuário por ID: $e');
    }
  }

  //-----------------------------
  //            read - User by Username
  //-----------------------------
  ///Pega dados do usuário pelo firebase através de um Username de usuário
  Future<Response> getUserbyUsername(
    UserGetModel data
  ) async {
    try {
      final doc = await ref
      .where(
        'username', 
        WhereFilter.equal, 
        data.username
      )
      .get();

      return Response.json(
        statusCode: HttpStatus.ok,
        body: UserDBModel.fromFirestore(doc.docs.first).toMap()
      );
    } catch (e) {
      throw Exception('Erro ao buscar usuário por ID: $e');
    }
  }

  //-----------------------------
  //            update - JWT
  //-----------------------------
  ///Atualizar uma instância no banco remoto
  Future<Response> updateUser(
    RequestContext context,
    UserModel user,
  ) async {
    try {
      final id = await _validateOpr(context);

      _log.info({
        'event': 'update_user_requested',
        'user_id': id,
      }.toString());

      await ref
          .doc(id)
          .update(user.toMap());

      _log.info({
        'event': 'user_updated',
        'user_id': id,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.accepted,
        body: 'Atualização bem sucedida',
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'update_user_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }

  //-----------------------------
  //            delete - JWT
  //-----------------------------
  ///Remoção de instância no banco remoto
  Future<Response> deleteUser(
    RequestContext context,
  ) async {
    try {
      final id = await _validateOpr(context);

      _log.info({
        'event': 'delete_user_requested',
        'user_id': id,
      }.toString());

      await ref
          .doc(id)
          .delete();

      final relacionamentos = firestore.collection('Relationship');

      final lista = await relacionamentos
          .where(
            'idUser',
            WhereFilter.equal,
            id,
          )
          .get();

      final formDados = <Map<String, dynamic>>[];

      for (var i = 0; i < lista.docs.length; i++) {
        formDados.add(
          UserDBModel.fromFirestore(lista.docs[i]).toMap(),
        );
      }

      for (var i = 0; i < lista.docs.length; i++) {
        await relacionamentos
            .doc(formDados[i]['id'].toString())
            .delete();
      }

      _log.info({
        'event': 'user_deleted',
        'user_id': id,
        'relationships_removed': lista.docs.length,
      }.toString());

      return Response.json(
        statusCode: HttpStatus.accepted,
        body: 'Deleção bem sucedida',
      );
    } catch (e, stackTrace) {
      _log.severe(
        {
          'event': 'delete_user_failed',
          'error': e.toString(),
        }.toString(),
        e,
        stackTrace,
      );

      rethrow;
    }
  }
}

///Criar Tokens JWT
String _jwtToken(
  Map<String, dynamic> map,
) {
  try {
    final jwt = JWT(
      {
        'id': map['id'],
        'name': map['name'],
        'username': map['username'],
        'email': map['email'],
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    return jwt.sign(
      SecretKey(_env['jwtSecretKey'].toString()),
      expiresIn: const Duration(days: 30),
    );
  } catch (_) {
    return '';
  }
}

//-----------------------------
//             RLS
//-----------------------------
///Limitar as operações relacionadas ao usuário
Future<String> _validateOpr(
  RequestContext context,
) async {
  final authHeader = context.request.headers['authorization'];

  if (authHeader == null) {
    throw Exception('Authorization não informado');
  }

  if (!authHeader.startsWith('Bearer ')) {
    throw Exception('Token inválido');
  }

  final token = authHeader.substring('Bearer '.length);

  final jwt = JWT.verify(
    token,
    SecretKey(_env['jwtSecretKey'].toString()),
  );

  final payload = jwt.payload as Map<String, dynamic>;

  return payload['id'].toString();
}
