///Classe para o modelo comum(Inserção no banco)
class UserGetModel{
  ///Modelo base
  UserGetModel({
    required this.username,
  });
  
  ///Conversão para o model
  factory UserGetModel.toModel (
    Map<String, dynamic> map,
    ){
    return UserGetModel(
      username:  map['username'].toString(),
    );
  }

  ///Campo username
  final String username;
  
  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'username': username,
    };
  }
}
