///Modelo a ser recebido pelas requisições
class TaskModel {
  ///Componentes do modelo
  TaskModel({
    required this.idColumn,
    required this.name,
    required this.criadoPor,
    required this.idTable,
    this.description,
    this.timeLimit,
    this.accountable
  });

  ///Conversão de map para model
  factory TaskModel.toModel ( Map<String, dynamic> map){
    final regex = RegExp(r'^[^\s@]+\.[^\s@]+@souunit\.com\.br$');
    
    if(regex.hasMatch(map['criadoPor'].toString())){
      return TaskModel(
        idColumn: map['idColumn'].toString(),
        name:  map['name'].toString(),
        description: map['description'].toString(),
        timeLimit: DateTime
          .parse(map['timeLimit'].toString())
          .toIso8601String(),
        idTable: map['idTable'].toString(),
        criadoPor: map['criadoPor'].toString(),
        accountable: map['accountable'].toString()
      );
    }else{
      throw Exception('Erro: email  da conta criadora não formatado');
    }
  }

  ///Campo idColumn
  final String idColumn;
  ///Campo name
  final String name;
  ///Campo criadoPor
  final String criadoPor;
  ///Campo idTable
  final String idTable;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String? timeLimit;
  ///Campo accountable
  final String? accountable;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idColumn': idColumn,
      'name': name,
      'description': description,
      'timeLimit': timeLimit,
      'idTable': idTable,
      'criadoPor': criadoPor,
      'accountable': accountable
    };
  }  
}
