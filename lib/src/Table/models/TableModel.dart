///Model para o corpo das requisições
class TableModel {
  ///Estrutura do Model
  TableModel({
    required this.name,
    required this.description,  
    required this.icon,  
  });
  
  ///Conversão de Map para Model
  factory TableModel.toModel ( Map<String, dynamic> map){
    return TableModel(
      name:        map['name'].toString(),
      description: map['description'].toString(),
      icon: int.parse(map['icon'].toString())
    );
  }

  ///Campo name
  final String name;
  ///Campo description
  final String description;
  ///Campo de ícone
  final int icon;

  ///Converção de model para Map
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'icon': icon
    };
  }
}
