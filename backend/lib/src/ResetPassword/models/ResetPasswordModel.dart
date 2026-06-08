///Classe para o modelo comum(Inserção no banco)
class ResetPasswordModel{
  ///Modelo base
  ResetPasswordModel({
    required this.email,
    required this.newPassword,
    required this.code,
  });
  
  ///Conversão para o model
  factory ResetPasswordModel.toModel (
      Map<String, dynamic> map,
      {bool validateEmail = true}){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(
      !validateEmail || regex.hasMatch(map['email'].toString())
      ){
      return ResetPasswordModel(
        email:  map['email'].toString(),
        newPassword: map['newPassword'].toString(),
        code: map['code'].toString()
      );
    } else {
      throw Exception('Email inválido');
    }
  }

  ///Campo email
  final String email;
  ///Campo newPassword
  final String newPassword;
  ///Campo code
  final String code;
  
  ///Conversão para Map
  Map<String, dynamic> toMap(){
    return {
      'email': email,
      'newPassword': newPassword,
      'code': code
    };
  }
}
