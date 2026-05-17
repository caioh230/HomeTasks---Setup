import 'package:google_cloud_firestore/google_cloud_firestore.dart';

///Modelo a ser retornado pelo banco remoto
class ColumnDBModel{
  ///Estrutura a ser seguida
  const ColumnDBModel({
    required this.id,
    required this.idTable,
    required this.name,
    required this.colorBackground,
  });


  ///Conversão de Map para DBModel
  factory ColumnDBModel.toModel(Map<String, dynamic> map){
    return ColumnDBModel(
      id: map['id'].toString(),
      idTable: map['idTable'].toString(),
      name: map['name'].toString(),
      colorBackground: map['colorBackground'].toString()
    );
  }

  ///Conversão de DocumentSnapshot para DBmodel
  factory ColumnDBModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc
    ){
      final dados = doc.data()!;

    return ColumnDBModel(
      id: doc.id,
      idTable: dados['idTable'].toString(),
      name: dados['name'].toString(),
      colorBackground: dados['colorBackground'].toString()
    );
  }

  ///Campo id
  final String id;
  ///Campo idTable
  final String idTable;
  ///Campo name
  final String name;
  ///Campo colorBackground
  final String colorBackground;

  

  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'idTable': idTable,
      'name': name,
      'colorBackground': colorBackground
    };
  }
}
