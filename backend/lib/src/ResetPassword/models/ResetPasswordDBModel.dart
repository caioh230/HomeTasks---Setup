import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Classe para o modelo completo (retorno do banco)
class ResetPasswordDBModel{
  ///Modelo Base
  const ResetPasswordDBModel({
    required this.id,
    required this.email,
    required this.newPassword,
    required this.code,
  });

  ///Conversão de map para DBmodel
  factory ResetPasswordDBModel.toModel(Map<String, dynamic> map){
    return ResetPasswordDBModel(
      id: map['id'].toString(),
      email: map['email'].toString(),
      newPassword: map['newPassword'].toString(),
      code: map['code'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory ResetPasswordDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

      return ResetPasswordDBModel(
        id: doc.id,
        email: dados['email'].toString(),
        newPassword: dados['newPassword'].toString(),
        code: dados['code'].toString()
      );
  }

  ///Campo id
  final String id;
  ///Campo email
  final String email;
  ///Campo newPassword
  final String newPassword;
  ///Campo code
  final String code;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'email': email,
      'newPassword': newPassword,
      'code': code
    };
  }
}
