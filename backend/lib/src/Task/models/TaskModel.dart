///Modelo a ser recebido pelas requisições
class TaskModel {
  ///Componentes do modelo
  TaskModel({
    required this.taskStatus,
    required this.name,
    required this.criadoPor,
    required this.idTable,
    required this.timeLimit,
    this.priority,
    this.description,
    this.completedAt,
    this.completedBy,
    this.accountable
  });

  ///Conversão de map para model
  factory TaskModel.toModel ( Map<String, dynamic> map){
    return TaskModel(
      taskStatus: map['taskStatus'].toString(),
      name:  map['name'].toString(),
      description: map['description']?.toString(),
      timeLimit: DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String(),
      completedAt: map['completedAt'] != null ? DateTime
        .parse(map['completedAt'].toString())
        .toIso8601String() : null,
      completedBy: map['completedBy']?.toString(),
      idTable: map['idTable'].toString(),
      criadoPor: map['criadoPor'].toString(),
      accountable: (map['accountable'] as List).cast<String>(),
      priority: map['priority']?.toString()
    );
  }

  ///Campo taskStatus
  final String taskStatus;
  ///Campo name
  final String name;
  ///Campo criadoPor
  final String criadoPor;
  ///Campo idTable
  final String idTable;
  ///Campo priority
  final String? priority;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String timeLimit;
  ///Campo completedAt
  final String? completedAt;
  ///Campo completedBy
  final String? completedBy;
  ///Campo accountable
  final List<String>? accountable;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'taskStatus': taskStatus,
      'name': name,
      'description': description,
      'timeLimit': timeLimit,
      'completedAt': completedAt,
      'completedBy': completedBy,
      'idTable': idTable,
      'priority': priority,
      'criadoPor': criadoPor,
      'accountable': accountable
    };
  }  
}

///Definir se um campo opcional segue as regras
bool evaluate(
  String data,
  RegExp regex
){
  if (
    data.isEmpty
    ||
    data == ''
  ){
      return true;
  }else{
    if(
      regex.hasMatch(data)
    ){
      return true;
    }else{
      return false;
    }
  }
}
