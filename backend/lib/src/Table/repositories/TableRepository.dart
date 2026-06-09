import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/Table/models/TableDBModel.dart';
import 'package:hometasks/src/Table/models/TableModel.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

/// Importação de dados sensíveis
final _env = DotEnv()..load();

/// Logger
final Logger _log = Logger('TableRepository');

/// Requisições diretas ao banco remoto
class TableRepository {
  /// Referência à coleção 'Table'
  final ref = firestore.collection('Table');

  //-----------------------------
  //            create - JWT
  //-----------------------------
  /// Criação de novo registro no banco remoto
  Future<Response> createTable(
    TableModel table,
    RequestContext context,
  ) async {
    _log.info('createTable iniciado');

    try {
      // Criação de id customizado
      const uuid = Uuid();
      final newId = uuid.v4();

      await ref.doc(newId).set(table.toMap());
      _log.info('Table criada | id=$newId');

      // Operação cascata
      final relationship = firestore.collection('Relationship');

      final idUser = await _jwtId(context);

      if (idUser.isEmpty) {
        _log.warning('createTable falhou: userId vazio');
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: 'Usuário inválido',
        );
      }

      final map = {
        'idUser': idUser,
        'idTable': newId,
        'roleName': 'owner',
        'valid': true,
      };

      await relationship.doc().set(map);

      _log.info('Relationship criada | user=$idUser | table=$newId');

      return Response.json(
        statusCode: HttpStatus.created,
        body: 'Criação de quadro bem sucedida',
      );
    } catch (e, st) {
      _log.severe('Erro em createTable', e, st);
      throw Exception(e);
    }
  }

  //-----------------------------
  //            read - reader
  //-----------------------------
  /// Leitura individual das mesas
  Future<Response> readTable(
    String id,
    RequestContext context,
  ) async {
    final role = await _validateOpr(id, context);

    _log.info('readTable | id=$id | role=$role');

    if (role != null) {
      try {
        final val = await ref.doc(id).get();
        final formDados = TableDBModel.fromFirestore(val);

        final relationships = firestore.collection('Relationship');
        final usersRef = firestore.collection('User');

        final members = await relationships
            .where('idTable', WhereFilter.equal, id)
            .get();

        final entries = await Future.wait(
          members.docs.map((doc) async {
            final data = doc.data();

            final idUser = data['idUser'];
            final roleName = data['roleName'];

            if (idUser == null || roleName == null) return null;

            final userSnap = await usersRef.doc(idUser.toString()).get();

            final username = userSnap.data()?['username'] ?? 'unknown';
            final name = userSnap.data()?['name'] ?? 'unknown';

            return MapEntry(
              idUser.toString(),
              {
                'roleName': roleName.toString(),
                'username': username,
                'name': name,
              },
            );
          }),
        );

        final membersList = Map<String, dynamic>.fromEntries(
          entries.whereType<MapEntry<String, dynamic>>(),
        );

        _log.info('readTable sucesso | id=$id | membros=${membersList.length}');

        return Response.json(
          statusCode: HttpStatus.ok,
          body: {
            ...formDados.toMap(),
            'roleName': role,
            'members': membersList,
          },
        );
      } catch (e, st) {
        _log.severe('Erro em readTable', e, st);
        throw Exception(e);
      }
    } else {
      _log.warning('readTable negado | id=$id');
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não possui acesso à este quadro',
      );
    }
  }

  //-----------------------------
  //            update - owner
  //-----------------------------
  /// Atualização individual da table
  Future<Response> updateTable(
    String id,
    TableModel table,
    RequestContext context,
  ) async {
    final role = await _validateOpr(id, context, 'owner');

    _log.info('updateTable | id=$id | role=$role');

    if (role != null) {
      try {
        await ref.doc(id).update(table.toMap());

        _log.info('updateTable sucesso | id=$id');

        return Response.json(
          statusCode: HttpStatus.accepted,
          body: 'Atualização de quadro bem sucedida',
        );
      } catch (e, st) {
        _log.severe('Erro em updateTable', e, st);
        throw Exception(e);
      }
    } else {
      _log.warning('updateTable negado | id=$id');
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não possui acesso à esta operação',
      );
    }
  }

  //-----------------------------
  //            delete - owner
  //-----------------------------
  /// Remoção individual das tables
  Future<Response> deleteTable(
    String id,
    RequestContext context,
  ) async {
    final role = await _validateOpr(id, context, 'owner');

    _log.info('deleteTable | id=$id | role=$role');

    if (role != null) {
      try {
        await ref.doc(id).delete();
        _log.info('Table deletada | id=$id');

        // Operação cascata
        final relationship = firestore.collection('Relationship');

        final lista = await relationship
            .where('idTable', WhereFilter.equal, id)
            .get();

        final formDados = <Map<String, dynamic>>[];

        for (var i = 0; i < lista.docs.length; i++) {
          formDados.add(TableDBModel.fromFirestore(lista.docs[i]).toMap());
        }

        for (var i = 0; i < lista.docs.length; i++) {
          await relationship.doc(formDados[i]['id'].toString()).delete();
        }

        _log.info('Cascade delete concluído | id=$id');

        return Response(
          statusCode: HttpStatus.accepted,
          body: 'Deleção de quadro bem sucedida',
        );
      } catch (e, st) {
        _log.severe('Erro em deleteTable', e, st);
        throw Exception(e);
      }
    } else {
      _log.warning('deleteTable negado | id=$id');
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: 'Você não possui acesso à esta operação',
      );
    }
  }
}

//-----------------------------
//      Permissão Cargos + RLS
//-----------------------------

Future<String?> _validateOpr(
  String idTable,
  RequestContext context, [
  String? minimalRole,
]) async {
  try {
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null) {
      _log.warning('_validateOpr sem authHeader');
      throw Exception('Authorization não informado');
    }

    if (!authHeader.startsWith('Bearer ')) {
      _log.warning('_validateOpr token inválido');
      throw Exception('Token inválido');
    }

    final token = authHeader.substring('Bearer '.length);

    final jwt = JWT.verify(
      token,
      SecretKey(_env['jwtSecretKey'].toString()),
    );

    final payload = jwt.payload as Map<String, dynamic>;

    final relationships = firestore.collection('Relationship');

    final data = await relationships
        .where('idUser', WhereFilter.equal, payload['id'].toString())
        .where('idTable', WhereFilter.equal, idTable)
        .get();

    if (data.docs.isEmpty) {
      _log.warning('_validateOpr sem relacionamento | user=${payload['id']}');
      return null;
    }

    const validRoles = ['reader', 'editor', 'owner'];
    final userRole = data.docs.first.data()['roleName']?.toString();

    if (!validRoles.contains(userRole)) {
      _log.warning('_validateOpr role inválido | role=$userRole');
      return null;
    }

    if (minimalRole == null) {
      return validRoles.contains(userRole) ? userRole : null;
    }

    final ok =
        validRoles.indexOf(userRole!) >= validRoles.indexOf(minimalRole);

    _log.fine('_validateOpr resultado | role=$userRole | ok=$ok');

    return ok ? userRole : null;
  } catch (e) {
    _log.severe('_validateOpr erro', e);
    return null;
  }
}

//-----------------------------
//             ID do usuário
//-----------------------------

Future<String> _jwtId(RequestContext context) async {
  try {
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null) {
      _log.warning('_jwtId sem authHeader');
      throw Exception('Authorization não informado');
    }

    if (!authHeader.startsWith('Bearer ')) {
      _log.warning('_jwtId token inválido');
      throw Exception('Token inválido');
    }

    final token = authHeader.substring('Bearer '.length);

    final jwt = JWT.verify(
      token,
      SecretKey(_env['jwtSecretKey'].toString()),
    );

    final payload = jwt.payload as Map<String, dynamic>;

    final id = payload['id'].toString();

    _log.fine('_jwtId sucesso | id=$id');

    return id;
  } catch (e) {
    _log.severe('_jwtId erro', e);
    return '';
  }
}