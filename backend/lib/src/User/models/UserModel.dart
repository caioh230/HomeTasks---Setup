///Classe para o modelo comum(Inserção no banco)
class UserModel{
  ///Modelo base
  UserModel({
    required this.email,
    required this.password,
    this.nickname,  
  });
  
  ///Conversão para o model
  factory UserModel.toModel ( Map<String, dynamic> map){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(regex.hasMatch(map['email'].toString())){
      return UserModel(
        nickname: map['nickname'].toString(),
        email:  map['email'].toString(),
        password: map['password'].toString()
      );
    }else{
      throw Exception('Erro: email não formatado');
    }
  }

  ///Campo nickname
  final String? nickname;
  ///Campo email
  final String email;
  ///Campo password
  final String password;
  
  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'nickname': nickname,
      'email': email,
      'password': password
    };
  }
}
