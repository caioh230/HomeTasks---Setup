import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Classe para o modelo completo (retorno do banco)
class UserDBModel{
  ///Modelo Base
  const UserDBModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.googleId,
  });

  ///Conversão de map para DBmodel
  factory UserDBModel.toModel(Map<String, dynamic> map){
    return UserDBModel(
      id: map['id'].toString(),
      name: map['name'].toString(),
      username: map['username'].toString(),
      email: map['email'].toString(),
      password: map['password'].toString(),
      googleId: map['googleId']?.toString(),
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory UserDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return UserDBModel(
      id: doc.id,
      name: dados['name'].toString(),
      username: dados['username'].toString(),
      email: dados['email'].toString(),
      password: dados['password'].toString(),
      googleId: dados['googleId']?.toString(),
    );
  }

  final String id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? googleId;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      if(googleId != null)
        'googleId': googleId,
    };
  }
}
