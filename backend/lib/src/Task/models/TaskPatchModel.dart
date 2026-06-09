///Modelo a ser recebido pelas requisições
class TaskPatchModel {
  ///Componentes do modelo
  TaskPatchModel({
    required this.idTable,
    this.taskStatus,
    this.name,
    this.timeLimit,
    this.priority,
    this.description,
    this.completedAt,
    this.completedBy,
    this.accountable
  });

  ///Conversão de map para model
  factory TaskPatchModel.toModel ( Map<String, dynamic> map){
    return TaskPatchModel(
      taskStatus: map['taskStatus']?.toString(),
      name:  map['name']?.toString(),
      description: map['description']?.toString(),
      timeLimit: map['timeLimit'] != null ? DateTime
        .parse(map['timeLimit'].toString())
        .toIso8601String() : null,
      completedAt: map['completedAt'] != null ? DateTime
        .parse(map['completedAt'].toString())
        .toIso8601String() : null,
      completedBy: map['completedBy']?.toString(),
      idTable: map['idTable'].toString(),
      accountable: map['accountable'] != null ?
        (map['accountable'] as List).cast<String>() : null,
      priority: map['priority']?.toString()
    );
  }

  ///Campo taskStatus
  final String? taskStatus;
  ///Campo name
  final String? name;
  ///Campo idTable
  final String idTable;
  ///Campo priority
  final String? priority;
  ///Campo description
  final String? description;
  ///Campo timeLimit
  final String? timeLimit;
  ///Campo completedAt
  final String? completedAt;
  ///Campo completedBy
  final String? completedBy;
  ///Campo accountable
  final List<String>? accountable;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable,
      if(accountable != null)
        'accountable': accountable,
      if(taskStatus != null)
        'taskStatus': taskStatus,
      if(name != null)
        'name': name,
      if(description != null)
        'description': description,
      if(timeLimit != null)
        'timeLimit': timeLimit,
      if(completedAt != null)
        'completedAt': completedAt,
      if(completedBy != null)
        'completedBy': completedBy,
      if(priority != null)
        'priority': priority,
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
