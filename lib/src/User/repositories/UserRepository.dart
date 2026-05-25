import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/User/models/UserDBModel.dart';
import 'package:hometasks/src/User/models/UserModel.dart';

///Importação de dados sensíveis
final env = DotEnv()..load();

///Responsável pela conexão com o banco remoto
class UserRepository {
  ///Referência à coleção User
  final ref = firestore.collection('User');

  //-----------------------------
  //            create - Cadastro
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createUser(
    UserModel user
    ) async {
      try{
        await ref
          .doc()
          .set(user.toMap());

        final token = jwtToken(user.toMap());

        return Response.json(
          statusCode: HttpStatus.created, 
          body: token
        );
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            read - JWT
  //-----------------------------
  ///Obter instância já registrada no banco remoto
  Future<Response> readUser(
    String id
    ) async{
      try{
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
  Future<Response> isUser(
    UserModel user
    ) async{
      try{
        final val = await ref
          .where(
            'email', 
            WhereFilter.equal, 
            user.email
          ).where(
            'password', 
            WhereFilter.equal, 
            user.password
          )
          .get(); 

        final data = UserDBModel.fromFirestore(val.docs.first);

        if (!val.empty){
          final token = jwtToken(data.toMap());

          return Response.json(
            statusCode: HttpStatus.found, 
            body:token
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.notFound
          );
        }
      }catch(e){
        throw Exception(e);
      }
  }

  //-----------------------------
  //            update - JWT
  //-----------------------------
  ///Atualizar uma instância no banco remoto
  Future<Response> updateUser(
    String id, 
    UserModel user
    ) async{ 
      try{
        await ref
          .doc(id)
          .update(user.toMap()); 

        return Response.json(
          statusCode: HttpStatus.accepted, 
          body: 'Atualização bem sucedida'
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
    String id
    ) async{
      try{
        await ref
          .doc(id)
          .delete();
        
        return Response(
          statusCode: HttpStatus.accepted, 
          body: 'Deleção bem sucedida'
        );
      }catch(e){
        throw Exception(e);
      }
    }
}

///Criar Tokens JWT
String jwtToken(
  Map<String, dynamic> map
  ){
    final jwt = JWT(
      // Payload
      {
        'id': map['id'],
        'nickname': map['nickname'],
        'password': map['password']
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    // Sign it (default with HS256 algorithm)
    return jwt.sign(SecretKey(env['jwtSecretKey'].toString()));
}
