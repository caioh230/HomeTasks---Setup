///Model para o corpo das requisições
class TableModel {
  ///Estrutura do Model
  TableModel({
    required this.name,
    required this.colorBackground,  
  });
  
  ///Conversão de Map para Model
  factory TableModel.toModel ( Map<String, dynamic> map){
    return TableModel(
      name:  map['name'].toString(),
      colorBackground: map['colorBackground'].toString()
    );
  }

  ///Campo name
  final String name;
  ///Campo colorBackground
  final String colorBackground;

  

  ///Converção de model para Map
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'colorBackground': colorBackground
    };
  }
}
