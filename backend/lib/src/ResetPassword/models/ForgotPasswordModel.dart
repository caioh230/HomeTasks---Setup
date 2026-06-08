///Classe para o modelo comum(Inserção no banco)
class ForgotPasswordModel{
  ///Modelo base
  ForgotPasswordModel({
    required this.email,
  });
  
  ///Conversão para o model
  factory ForgotPasswordModel.toModel (
      Map<String, dynamic> map,
      {bool validateEmail = true}){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(
      !validateEmail || regex.hasMatch(map['email'].toString())
      ){
      return ForgotPasswordModel(
        email:  map['email'].toString(),
      );
    } else {
      throw Exception('Email inválido');
    }
  }

  ///Campo email
  final String email;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'email': email,
    };
  }
}
