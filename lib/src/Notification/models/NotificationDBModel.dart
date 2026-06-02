import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Modelo a ser retornado pelo banco remoto
class NotificationDBModel{
  ///Estrutura a ser seguida
  const NotificationDBModel({
    required this.id,
    required this.content,
    required this.subject,
    required this.toUser,
    required this.fromUser,
    required this.read
  });


  ///Conversão de Map para DBModel
  factory NotificationDBModel.toModel(Map<String, dynamic> map){
    return NotificationDBModel(
      id:       map['id'].toString(),
      content:  map['content'].toString(),
      subject:  map['subject'].toString(),
      toUser:   map['toUser'].toString(),
      fromUser: map['fromUser'].toString(),
      read:     bool.parse(map['read'].toString())
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory NotificationDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

      return NotificationDBModel(
        id:       doc.id,
        content:  dados['content'].toString(),
        subject:  dados['subject'].toString(),
        toUser:   dados['toUser'].toString(),
        fromUser: dados['fromUser'].toString(),
        read:     bool.parse(dados['read'].toString())
      );
  }

  ///Campo id
  final String id;
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
      'id': id,
      'content': content,
      'subject': subject,
      'toUser': toUser,
      'fromUser': fromUser,
      'read': read
    };
  }
}
