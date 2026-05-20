///Modelo a ser recebido pelas requisições
class RelationshipModel {
  ///Componentes do modelo
  RelationshipModel({
    required this.idUser,
    required this.idTable,
    required this.idRole,
  });

  ///Conversão de map para model
  factory RelationshipModel.toModel ( Map<String, dynamic> map){
    return RelationshipModel(
      idUser: map['idUser'].toString(),
      idTable:  map['idTable'].toString(),
      idRole:  map['idRole'].toString(),
    );
  }

  ///Campo idUser
  final String idUser;
  ///Campo idTable
  final String idTable;
  ///Campo idRole
  final String idRole;

  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'idUser': idUser,
      'idTable': idTable,
      'idRole': idRole,
    };
  }  
}
