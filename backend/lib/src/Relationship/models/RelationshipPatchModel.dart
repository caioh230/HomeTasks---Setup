///Modelo a ser recebido pelas requisições
class RelationshipPatchModel {
  ///Componentes do modelo
  RelationshipPatchModel({
    this.valid,
  });

  ///Conversão de map para model
  factory RelationshipPatchModel.toModel ( Map<String, dynamic> map){
    final list = ['reader', 'editor', 'owner'];
    if(
      list.contains(map['roleName'].toString())
    ){
      return RelationshipPatchModel(
        valid:      bool.parse(map['valid'].toString())
      );
    }else {
      throw Exception('Cargo inexistente, ignorando acesso');
    }
  }

  ///Campo valid
  final bool? valid;
  
  ///Conversão do Model para Map
  Map<String, dynamic> toMap(){
    return {
      'valid': valid
    };
  }  
}
