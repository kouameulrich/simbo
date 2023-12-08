
class TypeActiviteCommerciale {
int? id;
String? type;
String? description;

TypeActiviteCommerciale({this.id, this.type, this.description,
  });

TypeActiviteCommerciale.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  type = json['type'];
  description = json['description'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = id;
  data['type'] = type;
  data['description'] = description;
  return data;
}
}