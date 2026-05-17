///Modelo a ser enviado pelas requisições
class ColumnModel {
  ///Estrutura do modelo
  ColumnModel({
    required this.idTable,
    required this.name,
    required this.colorBackground,  
  });

  ///Converção de Map para Model
  factory ColumnModel.toModel ( Map<String, dynamic> map){
    return ColumnModel(
      idTable:int.parse(map['idTable'].toString()),
      name:  map['name'].toString(),
      colorBackground: map['colorBackground'].toString()
    );
  }


  ///Campo idTable
  final int idTable;
  ///Campo name
  final String name;
  ///Campo colorBackground
  final String colorBackground;
  
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable,
      'name': name,
      'colorBackground': colorBackground
    };
  }
}
