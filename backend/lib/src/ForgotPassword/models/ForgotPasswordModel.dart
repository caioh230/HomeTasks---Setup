///Classe para o modelo comum(Inserção no banco)
class ForgotPasswordModel{
  ///Modelo base
  ForgotPasswordModel({
    required this.email,
    this.code,
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
        code:   map['code'].toString(),
      );
    } else {
      throw Exception('Email inválido');
    }
  }

  ///Campo email
  final String email;
  ///Campo code
  final String? code;

  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'email': email,
      'code': code
    };
  }
}
