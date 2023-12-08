
class TypeEquipement {
int? id ;
String? libelle ;
String? sigle;

TypeEquipement({this.id, this.libelle, this.sigle});

TypeEquipement.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  libelle = json['libelle'];
  sigle = json['sigle'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = id;
  data['libelle'] = libelle;
  data['sigle'] = sigle;
  return data;
}
}