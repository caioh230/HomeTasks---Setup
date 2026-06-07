///Modelo a ser recebido pelas requisições
class RelationshipModel {
  ///Componentes do modelo
  RelationshipModel({
    required this.idUser,
    required this.idTable,
    required this.roleName,
    required this.tableName,
  });

  ///Conversão de map para model
  factory RelationshipModel.toModel ( Map<String, dynamic> map){
    final list = ['reader', 'editor', 'owner'];
    if(
      list.contains(map['roleName'].toString())
    ){
      return RelationshipModel(
        idUser: map['idUser'].toString(),
        idTable:  map['idTable'].toString(),
        roleName:  map['roleName'].toString(),
        tableName: map['tableName'].toString(),
      );
    }else {
      throw Exception('Email inválido');
    }
  }

  ///Campo idUser
  final String idUser;
  ///Campo idTable
  final String idTable;
  ///Campo roleName
  final String roleName;
  ///Campo tableName
  final String tableName;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idUser': idUser,
      'idTable': idTable,
      'roleName': roleName,
      'tableName': tableName,
    };
  }  
}
