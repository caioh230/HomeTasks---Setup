import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';

import 'package:hometasks/src/User/models/UserDBModel.dart';
import 'package:hometasks/src/User/models/UserGetModel.dart';
import 'package:hometasks/src/User/models/UserModel.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Responsável pela conexão com o banco remoto
class UserRepository {
  ///Referência à coleção User
  final ref = firestore.collection('User');

  //-----------------------------
  //            create - Cadastro
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createUser(UserModel user) async {
    if (
      user.email.isEmpty ||
      user.password.isEmpty ||
      (user.username?.isEmpty ?? true) ||
      (user.name?.isEmpty ?? true)
    ) {
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
      print(stackTrace);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Obter instância já registrada no banco remoto
  Future<Response> readUser(
    RequestContext context
    ) async{
      try{
        final id = await _validateOpr(context);

        final val = await ref
          .doc(id)
          .get();

        final formDados = UserDBModel.fromFirestore(val);

        return Response.json(
          statusCode: HttpStatus.found, 
          body: formDados.toMap()
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - Login
  //-----------------------------
  ///Verificar se uma instância existe no banco remoto e retorna um JWT
  Future<Response> isUser(UserModel user) async {
    try {
      final identifier = user.email; //email/username
      var val = await ref
          .where('email', WhereFilter.equal, identifier)
          .where('password', WhereFilter.equal, user.password)
          .get();

      if (val.empty &&
      (identifier.startsWith('@') ||
      !identifier.contains('@'))) {
        val = await ref
            .where('username', WhereFilter.equal, identifier)
            .where('password', WhereFilter.equal, user.password)
            .get();
      }

      if (val.empty) {
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'E-mail ou senha inválidos',
        );
      }

      final doc = val.docs.first;
      final data = UserDBModel.fromFirestore(doc).toMap();

      final token = _jwtToken({
        'id': data['id'],
        'name': data['name'],
        'username': data['username'],
        'email': data['email'],
      });

      if (token.isEmpty) {
        return Response.json(
          statusCode: HttpStatus.internalServerError,
          body: 'Erro ao gerar token',
        );
      }

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
    } catch (e) {
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
      final payload = _verifyJwtToken(token);

      if (payload == null || !payload.containsKey('id')) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: 'Token inválido',
        );
      }

      final userId = payload['id'].toString();

      final user = await readUserById(userId);

      if (user == null) {
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: 'Usuário não encontrado',
        );
      }

      return Response.json(
        statusCode: HttpStatus.ok,
        body: {
          'id': user.id,
          'name': user.name,
          'username': user.username,
          'email': user.email,
        }
      );
    } catch (e) {
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
      return null;
    }
  }

  //-----------------------------
  //            read - User by id
  //-----------------------------
  ///Pega dados do usuário pelo firebase através de um ID de usuário
  Future<UserDBModel?> readUserById(String id) async {
    try {
      final doc = await ref.doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return UserDBModel.fromFirestore(doc);
    } catch (e) {
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
    UserModel user
    ) async{ 
      try{
        final id = await _validateOpr(context);

        await ref
          .doc(id)
          .update(user.toMap()); 

        return Response.json(
          statusCode: HttpStatus.accepted, 
          body: 'Atualização bem sucedida',
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            delete - JWT
  //-----------------------------
  ///Remoção de instância no banco remoto
  Future<Response> deleteUser(
    RequestContext context,
    ) async{
      try{
        final id = await _validateOpr(context);
        
        await ref
          .doc(id)
          .delete();
        
        //Operação cascata
        final relacionamentos = firestore.collection('Relationship');

        final lista = await relacionamentos
        .where(
          'idUser', 
          WhereFilter.equal, 
          id
        )
        .get();

        final formDados = <Map<String, dynamic>>[];

        for (var i = 0; i < lista.docs.length; i++){
          formDados.add(UserDBModel.fromFirestore(lista.docs[i]).toMap());
        }

        for (var i = 0; i < lista.docs.length; i++){
          await relacionamentos
          .doc(formDados[i]['id'].toString())
          .delete();
        }

        return Response.json(
          statusCode: HttpStatus.accepted, 
          body: 'Deleção bem sucedida',
        );
      }catch(e){
        throw Exception(e);
      }
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
  //print(token);
  final jwt = JWT.verify(
    token,
    SecretKey(_env['jwtSecretKey'].toString()),
  );

  final payload = jwt.payload as Map<String, dynamic>;

  return payload['id'].toString();
}
