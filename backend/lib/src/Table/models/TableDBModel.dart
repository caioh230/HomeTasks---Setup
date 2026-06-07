import 'package:google_cloud_firestore/google_cloud_firestore.dart';


///Model para retorno do banco remoto
class TableDBModel{
  ///Estrutura a ser sequida
  const TableDBModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon, 
  });

  ///Conversão de Map para DBModel
  factory TableDBModel.toModel(Map<String, dynamic> map){
    return TableDBModel(
      id: map['id'].toString(),
      name: map['name'].toString(),
      description: map['description'].toString(),
      icon: map['icon'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory TableDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return TableDBModel(
      id: doc.id,
      name: dados['name'].toString(),
      description: dados['description'].toString(),
      icon: dados['icon'].toString()
    );
  }

  ///Campo id
  final String id;
  ///Campo name
  final String name;
  ///Campo description
  final String description;
  ///Campo de ícone
  final String icon;
  
  ///Conversão de DBModel para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon
    };
  }   
}
