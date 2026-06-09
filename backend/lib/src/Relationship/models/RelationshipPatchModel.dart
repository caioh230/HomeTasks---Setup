///Modelo a ser recebido pelas requisições
class RelationshipPatchModel {
  ///Componentes do modelo
  RelationshipPatchModel({
    this.valid,
  });

  ///Conversão de map para model
  factory RelationshipPatchModel.toModel ( Map<String, dynamic> map){
    return RelationshipPatchModel(
      valid: bool.parse(map['valid'].toString())
    );
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
