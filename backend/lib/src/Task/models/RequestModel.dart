///Modelo a ser enviado pelas requisições
class RequestModel {
  ///Estrutura do modelo
  RequestModel({
    required this.idTable,
    required this.taskStatus,
  });

  ///Converção de Map para Model
  factory RequestModel.toModel ( Map<String, dynamic> map){
    return RequestModel(
      idTable:map['idTable'].toString(),
      taskStatus:map['taskStatus'].toString()
    );
  }

  ///Campo idTable
  final String idTable;
  ///Campo taskStatus
  final String taskStatus;
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable,
      'taskStatus': taskStatus
    };
  }
}
