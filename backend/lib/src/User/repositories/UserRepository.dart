import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/User/models/UserDBModel.dart';
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
  Future<Response> createUser(
    UserModel user
    ) async {
      try{
        late final bool val;
        try{  
          await ref.where(
            'email', 
            WhereFilter.equal, 
            user.email
          ).get();

          val = false;
        }catch(_){
        }

        if(
          !val
        ){
          await ref
            .doc()
            .set(user.toMap());
          //Criação do tokenJWT
          final token = _jwtToken(user.toMap());

          if(token != ''){
            return Response.json(
              statusCode: HttpStatus.created, 
              body: token
            );
          }else{
            return Response.json(
              statusCode: HttpStatus.badRequest, 
              body: 'Faltam campos para cadastrar o usuário'
            );
          }
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest, 
            body: 'Email já cadastrado no sistema'
          );
        }
      }catch(e){
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
        final id = _validateOpr(context);

        final val = await ref
          .doc(id.toString())
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
          final token = _jwtToken(data.toMap());

          if(token != ''){
            return Response.json(
              statusCode: HttpStatus.found, 
              body:token
            );
          }else{
            return Response.json(
            statusCode: HttpStatus.notFound,
            body: 'E-mail ou senha inválidos'
          );
          }
        }else{
          return Response.json(
            statusCode: HttpStatus.notFound,
            body: 'E-mail ou senha inválidos'
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
    RequestContext context,
    UserModel user
    ) async{ 
      try{
        final id = _validateOpr(context);

        await ref
          .doc(id.toString())
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
    RequestContext context,
    ) async{
      try{
        final id = _validateOpr(context);
        
        await ref
          .doc(id.toString())
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
String _jwtToken(
  Map<String, dynamic> map
  ){
    try{
      final jwt = JWT(
        // Payload
        {
          'id': map['id'],
          'nickname': map['nickname'],
          'email': map['email'],
          'password': map['password']
        },
        issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
      );

      // Sign it (default with HS256 algorithm)
      return jwt.sign(SecretKey(_env['jwtSecretKey'].toString()));
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
)async{
  try{
    //Obtenção de dados do usuário
    final request = context.request;
    final header = request.headers['authorization'];
                
    final jwt = JWT.verify(
      header!, 
      SecretKey(_env['jwtSecretKey'].toString())
    );

    final payload = jwt.payload as Map<String, dynamic>;
    
    return payload['id'].toString();
  }catch(e){
    return '';
  }
}
