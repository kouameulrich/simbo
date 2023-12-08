
class TypeContribuable {
  String? label;
  String? value;

  TypeContribuable(
     this.label,
     this.value,
  );

  TypeContribuable.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}