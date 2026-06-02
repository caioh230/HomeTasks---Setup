///Modelo a ser enviado pelas requisições
class RequestModel {
  ///Estrutura do modelo
  RequestModel({
    required this.idTable,
  });

  ///Converção de Map para Model
  factory RequestModel.toModel ( Map<String, dynamic> map){
    return RequestModel(
      idTable:map['idTable'].toString(),
    );
  }


  ///Campo idTable
  final String idTable;
  
  ///Converção de Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idTable': idTable
    };
  }
}
