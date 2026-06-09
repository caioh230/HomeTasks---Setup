import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Classe para o modelo completo (retorno do banco)
class ForgotPasswordDBModel{
  ///Modelo Base
  const ForgotPasswordDBModel({
    required this.id,
    required this.email,
    required this.code,
  });

  ///Conversão de map para DBmodel
  factory ForgotPasswordDBModel.toModel(Map<String, dynamic> map){
    return ForgotPasswordDBModel(
      id: map['id'].toString(),
      email: map['email'].toString(),
      code: map['code'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory ForgotPasswordDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

      return ForgotPasswordDBModel(
        id: doc.id,
        email: dados['email'].toString(),
        code: dados['code'].toString()
      );
  }

  ///Campo id
  final String id;
  ///Campo email
  final String email;
  ///Campo code
  final String code;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'email': email,
      'code': code
    };
  }
}
