///Classe para o modelo comum(Inserção no banco)
class UserModel{
  ///Modelo base
  UserModel({
    required this.email,
    required this.password,
    this.name,
    this.username,
  });
  
  ///Conversão para o model
  factory UserModel.toModel (
      Map<String, dynamic> map,
      {bool validateEmail = true}){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(
      !validateEmail || regex.hasMatch(map['email'].toString())
      ){
      final username = (map['username'] as String?)
        ?.trim()
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]'), '');
      return UserModel(
        name: map['name'].toString(),
        username: username,
        email:  map['email'].toString(),
        password: map['password'].toString()
      );
    } else {
      throw Exception('Email inválido');
    }
  }

  ///Campo name
  final String? name;
  ///Campo username
  final String? username;
  ///Campo email
  final String email;
  ///Campo password
  final String password;
  
  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password
    };
  }
}
