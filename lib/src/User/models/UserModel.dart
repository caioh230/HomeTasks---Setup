class UserModel {
  final String? nickname;
  final String email;
  final String password;
  
  
  UserModel({
    this.nickname,
    required this.email,
    required this.password,  
  });

  Map<String, dynamic> toMap(){
    return {
      'nickname': nickname,
      'email': email,
      'password': password
    };
  }

  factory UserModel.toModel ( Map<String, dynamic> map){
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    
    if(regex.hasMatch(map['email'].toString())){
      return UserModel(
        nickname: map['nickname'].toString(),
        email:  map['email'].toString(),
        password: map['password'].toString()
      );
    }else{
      throw("Erro: email não formatado");
    }
  }
}