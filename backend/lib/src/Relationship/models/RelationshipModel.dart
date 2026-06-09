///Modelo a ser recebido pelas requisições
class RelationshipModel {
  ///Componentes do modelo
  RelationshipModel({
    required this.idUser,
    required this.idTable,
    required this.tableName,
    required this.roleName,
    required this.valid,
  });

  ///Conversão de map para model
  factory RelationshipModel.toModel ( Map<String, dynamic> map){
    final list = ['reader', 'editor', 'owner'];
    if(
      list.contains(map['roleName'].toString())
    ){
      return RelationshipModel(
        idUser:     map['idUser'].toString(),
        idTable:    map['idTable'].toString(),
        tableName:    map['tableName'].toString(),
        roleName:   map['roleName'].toString(),
        valid:      bool.parse(map['valid'].toString())
      );
    }else {
      throw Exception('Cargo inexistente, ignorando acesso');
    }
  }

  ///Campo idUser
  final String idUser;
  ///Campo idTable
  final String idTable;
  ///Campo tableName
  final String tableName;
  ///Campo roleName
  final String roleName;
  ///Campo valid
  final bool valid;
  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idUser': idUser,
      'idTable': idTable,
      'tableName': tableName,
      'roleName': roleName,
      'valid': valid
    };
  }  
}
