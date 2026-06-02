///Modelo a ser enviado pelas requisições
class RequestModel {
  ///Estrutura do modelo
  RequestModel({
    required this.idTable,
    required this.idColumn,
  });

  ///Converção de Map para Model
  factory RequestModel.toModel ( Map<String, dynamic> map){
    return RequestModel(
      idTable:map['idTable'].toString(),
      idColumn:map['idColumn'].toString()
    );
  }

  ///Campo idTable
  final String idTable;
  ///Campo idColumn
  final String idColumn;
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable,
      'idColumn': idColumn
    };
  }
}
