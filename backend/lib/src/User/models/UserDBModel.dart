import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Classe para o modelo completo (retorno do banco)
class UserDBModel{
  ///Modelo Base
  const UserDBModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.password,
  });

  ///Conversão de map para DBmodel
  factory UserDBModel.toModel(Map<String, dynamic> map){
    return UserDBModel(
      id: map['id'].toString(),
      nickname: map['nickname'].toString(),
      email: map['email'].toString(),
      password: map['password'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory UserDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return UserDBModel(
      id: doc.id,
      nickname: dados['nickname'].toString(),
      email: dados['email'].toString(),
      password: dados['password'].toString()
    );
  }

  ///Campo id
  final String id;
  ///Campo nickname
  final String nickname;
  ///Campo email
  final String email;
  ///Campo password
  final String password;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'password': password
    };
  }
}
