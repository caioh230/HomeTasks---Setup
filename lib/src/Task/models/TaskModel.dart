///Modelo a ser recebido pelas requisições
class TaskModel {
  ///Componentes do modelo
  TaskModel({
    required this.idColumn,
    required this.name,
    this.description,
    this.timeLimit,
    this.idUser,
  });

  ///Conversão de map para model
  factory TaskModel.toModel ( Map<String, dynamic> map){
    return TaskModel(
      idColumn: map['idColumn'].toString(),
      name:  map['name'].toString(),
      description: map['description'].toString(),
      timeLimit: DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String(),
      idUser: map['idUser'].toString()
    );
  }

  ///Campo idColumn
  final String idColumn;
  ///Campo name
  final String name;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String? timeLimit;
  ///Campo idUser
  final String? idUser;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idColumn': idColumn,
      'name': name,
      'description': description,
      'timeLimit': timeLimit,
      'idUser': idUser
    };
  }  
}
