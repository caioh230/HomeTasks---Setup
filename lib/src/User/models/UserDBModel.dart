///Classe para o modelo completo (retorno do banco)
class UserDBModel{
  ///Modelo Base
  const UserDBModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.password,
  });

  ///Conversão para o model
  factory UserDBModel.toModel(Map<String, dynamic> map){
    return UserDBModel(
      id: int.parse(map['id'].toString()),
      nickname: map['nickname'].toString(),
      email: map['email'].toString(),
      password: map['password'].toString()
    );
  }

  ///Campo id
  final int id;
  ///Campo nickname
  final String nickname;
  ///Campo email
  final String email;
  ///Campo password
  final String password;

  ///Conversão para Map
  Map<String, dynamic> toMap(UserDBModel user){
    return {
      'id': user.id,
      'nickname': user.nickname,
      'email': user.email,
      'password': user.password
    };
  }
}
