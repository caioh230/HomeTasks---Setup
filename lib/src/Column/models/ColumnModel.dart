///Modelo a ser enviado pelas requisições
class ColumnModel {
  ///Estrutura do modelo
  ColumnModel({
    required this.idTable,
    required this.name,
    required this.colorBackground,  
    required this.criadoPor,  
  });

  ///Converção de Map para Model
  factory ColumnModel.toModel ( Map<String, dynamic> map){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(regex.hasMatch(map['criadoPor'].toString())){
      return ColumnModel(
        idTable:map['idTable'].toString(),
        name:  map['name'].toString(),
        colorBackground: map['colorBackground'].toString(),
        criadoPor: map['criadoPor'].toString()
      );
    }else{
      throw Exception('Erro: email  da conta criadora não formatado');
    }
  }


  ///Campo idTable
  final String idTable;
  ///Campo name
  final String name;
  ///Campo colorBackground
  final String colorBackground;
  ///Campo criadoPor
  final String criadoPor;
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable,
      'name': name,
      'colorBackground': colorBackground,
      'criadoPor': criadoPor
    };
  }
}
