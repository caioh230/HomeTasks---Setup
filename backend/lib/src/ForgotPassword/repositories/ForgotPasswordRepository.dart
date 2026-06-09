import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:dotenv/dotenv.dart';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';

import 'package:hometasks/config/DataBase_client.dart';
import 'package:hometasks/src/ForgotPassword/models/ForgotPasswordModel.dart';
import 'package:hometasks/src/User/models/UserDBModel.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:uuid/uuid.dart';

///Importação de dados sensíveis
final _env = DotEnv()..load();

///Responsável pela conexão com o banco remoto
class ForgotPasswordRepository {
  ///Referência à coleção ForgotPassword
  final ref = firestore.collection('ForgotPassword');

  //-----------------------------
  //            create
  //-----------------------------
  ///Criação de uma nova instância no banco remoto
  Future<Response> createForgotPassword(
    ForgotPasswordModel forgotPasswordModel
    ) async {
      try {        
        late final bool val;
        try{  
          final pesq = firestore.collection('User');
          
          await pesq.where(
            'email', 
            WhereFilter.equal, 
            forgotPasswordModel.email
          ).get();

          val = true;
        }catch(_){
        }

        if(
          val
        ){
          //Criação de id customizado
          const uuid = Uuid();
          final newId = uuid.v4();

          final random = Random();

          final model = ForgotPasswordModel.toModel(
            {
              'email': forgotPasswordModel.email,
              'code': (100000 + random.nextInt(900000)).toString()
            }
          );

          //Emissão de email
           final smtpServer = gmail(
            'caiohchagas92@gmail.com',
            'ykkg tbqj mioo ttrm',
          );

          final message =
              Message()
                ..from = const Address('caiohchagas92@gmail.com', 'HomeTasks')
                ..recipients.add(forgotPasswordModel.email)
                ..subject = 'Código de recuperação de senha'
                ..text = 'Olá! Seu código de recuperação de senha é ${model.code}.'
                ..html = '<h1>Olá!</h1><p>Email enviado pela equipe do Hometasks.</p>';

          await send(message, smtpServer);

          //Interação com o banco remoto
          await ref
          .doc(newId)
          .set(
            model.toMap()
          );

          return Response.json(
            statusCode: HttpStatus.created,
            body: {
              'code': model.toMap(),
              'id': newId
            },
          );
        }else{
          return Response.json(
            statusCode: HttpStatus.badRequest,
            body: 'Email não registrado no sistema'
          );
        }
      } catch (e) {
        throw Exception(e);
      }
  }

  //-----------------------------
  //            get - JWT
  //-----------------------------
  ///Atualizar uma instância no banco remoto
  Future<Response> getForgotPassword(
    String id,
    RequestContext context,
    ) async{ 
      try{
        await ref
          .doc(id)
          .get();

        final pesq = firestore.collection('User');

        //Obtendo de senha do usuário          
        final user = await pesq.where(
          'email', 
          WhereFilter.equal, 
          await _validateUsr(context)
        ).get();

        final mod = UserDBModel.fromFirestore(user.docs.first);
        
        return Response.json(
          statusCode: HttpStatus.accepted, 
          body: mod.password,
        );
      }catch(e){
        throw Exception(e);
      }
  }
}

//-----------------------------
//             RLS
//-----------------------------
///Buscar o id do usuário
Future<String> _validateUsr(
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
