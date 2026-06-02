///Modelo a ser enviado pelas requisições
class NotificationModel {
  ///Estrutura do modelo
  NotificationModel({
    required this.content,
    required this.subject,
    required this.toUser,  
    required this.fromUser,  
    required this.read,
  });

  ///Converção de Map para Model
  factory NotificationModel.toModel ( Map<String, dynamic> map){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(
      regex.hasMatch(map['fromUser'].toString()) 
      && 
      regex.hasMatch(map['toUser'].toString()
      )){
        return NotificationModel(
          content:  map['content'].toString(),
          subject:  map['subject'].toString(),
          toUser:   map['toUser'].toString(),
          fromUser: map['fromUser'].toString(),
          read:     bool.parse(map['read'].toString())
        );
    }else{
      throw Exception('Erro: email  da conta criadora não formatado');
    }
  }


  ///Campo content
  final String content;
  ///Campo subject
  final String subject;
  ///Campo toUser
  final String toUser;
  ///Campo fromUser
  final String fromUser;
  ///Campo read
  final bool read;
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'content': content,
      'subject': subject,
      'toUser': toUser,
      'fromUser': fromUser,
      'read': read
    };
  }
}
