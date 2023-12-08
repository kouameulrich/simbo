
class Facturedto{
  int? id;
  String? numeroFacture;
  double? montantPaye;
  String? numeroCompte;
  String? matriculeEquipement;
  String? matriculeAgent;
  String? recuPaiement;

  Facturedto({
      this.id,
      this.numeroFacture,
      this.montantPaye,
      this.numeroCompte,
      this.matriculeEquipement,
      this.matriculeAgent,
      this.recuPaiement});

  @override
  String toString() {
    return 'Facturedto{id: $id, numeroFacture: $numeroFacture, montantPaye: $montantPaye, numeroCompte: $numeroCompte, matriculeEquipement: $matriculeEquipement, matriculeAgent: $matriculeAgent, recuPaiement: $recuPaiement}';
  }

  Facturedto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numeroFacture = json['numeroFacture'];
    montantPaye = json['montantPaye'];
    numeroCompte = json['numeroCompte'];
    matriculeEquipement = json['matriculeEquipement'];
    matriculeAgent = json['matriculeAgent'];
    recuPaiement = json['recuPaiement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numeroFacture'] = numeroFacture;
    data['montantPaye'] = montantPaye;
    data['numeroCompte'] = numeroCompte;
    data['matriculeEquipement'] = matriculeEquipement;
    data['matriculeAgent'] = matriculeAgent;
    data['recuPaiement'] = recuPaiement;
    return data;
  }
}