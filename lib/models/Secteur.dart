
class Secteur {
  int? id ;
  String? designation;
  String? description ;
  String? code  ;
  String? sigle ;
  String? collectiviteCode ;

  Secteur({this.id, this.designation, this.description,
           this.code, this.sigle, this.collectiviteCode });

 Secteur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designation = json['designation'];
    description = json['description'];
    code = json['code'];
    sigle = json['sigle'];
    collectiviteCode = json['collectiviteCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['designation'] = designation;
    data['description'] = description;
    data['code'] = code;
    data['sigle'] = sigle;
    data['collectiviteCode'] = collectiviteCode;
    return data;
  }
}