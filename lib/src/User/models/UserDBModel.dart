class UserDBModel{
  final int id;
  final String nickname;
  final String email;
  final String password;
  
  
  const UserDBModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap(UserDBModel user){
    return {
      'id': user.id,
      'nickname': user.nickname,
      'email': user.email,
      'password': user.password
    };
  }

   UserDBModel toModel(Map<String, dynamic> map){
    return UserDBModel(
      id: int.parse(map['id'].toString()),
      nickname: map['nickname'].toString(),
      email: map['email'].toString(),
      password: map['password'].toString()
    );
  }
}