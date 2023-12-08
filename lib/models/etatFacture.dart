
class EtatFacture {
  String? label;
  String? value;

  EtatFacture(
      this.label,
      this.value,
      );

  EtatFacture.fromJson(Map<String, String> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['label'] = label!;
    data['value'] = value!;
    return data;
  }
}