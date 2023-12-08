class Facture {
  int id=0;
  String? numeroFacture;
  String? dateEdition;
  double? montantApayer;
  double? montantAnterieurDu;
  double? montantPaye;
  double? resteAPayer;
  String? etatFacture;
  String? dateLimitePaiement;
  String? periodiciteTaxe;
  String? numeroCompte;
  String? matriculeContribuable;
  String? nomContribuable;
  String? prenomContribuable;
  String? telephoneContribuable;
  String? matriculeEquipement;
  String? recuPaiement;
  String? matriculeAgent;
  String? dateOperation;

  @override
  String toString() {
    return 'Facture{id: $id, numeroFacture: $numeroFacture, dateEdition: $dateEdition, montantApayer: $montantApayer, montantAnterieurDu: $montantAnterieurDu, montantPaye: $montantPaye, resteAPayer: $resteAPayer, etatFacture: $etatFacture, dateLimitePaiement: $dateLimitePaiement, periodiciteTaxe: $periodiciteTaxe, numeroCompte: $numeroCompte, matriculeContribuable: $matriculeContribuable, nomContribuable: $nomContribuable, prenomContribuable: $prenomContribuable, telephoneContribuable: $telephoneContribuable, matriculeEquipement: $matriculeEquipement, recuPaiement: $recuPaiement, dateOperation: $dateOperation}';
  }

  Facture(
      {required this.id,
      this.numeroFacture,
      this.dateEdition,
      this.montantApayer,
      this.montantAnterieurDu,
      this.montantPaye,
      this.resteAPayer,
      this.etatFacture,
      this.dateLimitePaiement,
      this.periodiciteTaxe,
      this.numeroCompte,
      this.matriculeContribuable,
      this.nomContribuable,
      this.prenomContribuable,
      this.telephoneContribuable,
      this.matriculeEquipement,
      this.recuPaiement,
      this.matriculeAgent,
      this.dateOperation});

  Facture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numeroFacture = json['numeroFacture'];
    dateEdition = json['dateEdition'];
    montantApayer = json['montantApayer'];
    montantAnterieurDu = json['montantAnterieurDu'];
    montantPaye = json['montantPaye'];
    resteAPayer = json['resteAPayer'];
    etatFacture = json['etatFacture'];
    dateLimitePaiement = json['dateLimitePaiement'];
    periodiciteTaxe = json['periodiciteTaxe'];
    numeroCompte = json['numeroCompte'];
    matriculeContribuable = json['matriculeContribuable'];
    nomContribuable = json['nomContribuable'];
    prenomContribuable = json['prenomContribuable'];
    telephoneContribuable = json['telephoneContribuable'];
    matriculeEquipement = json['matriculeEquipement'];
    recuPaiement = json['recuPaiement'];
    dateOperation = json['dateOperation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numeroFacture'] = numeroFacture;
    data['dateEdition'] = dateEdition;
    data['montantApayer'] = montantApayer;
    data['montantAnterieurDu'] = montantAnterieurDu;
    data['montantPaye'] = montantPaye;
    data['resteAPayer'] = resteAPayer;
    data['etatFacture'] = etatFacture;
    data['dateLimitePaiement'] = dateLimitePaiement;
    data['periodiciteTaxe'] = periodiciteTaxe;
    data['numeroCompte'] = numeroCompte;
    data['matriculeContribuable'] = matriculeContribuable;
    data['nomContribuable'] = nomContribuable;
    data['prenomContribuable'] = prenomContribuable;
    data['telephoneContribuable'] = telephoneContribuable;
    data['matriculeEquipement'] = matriculeEquipement;
    data['recuPaiement'] = recuPaiement;
    data['dateOperation'] = dateOperation;
    return data;
  }
}
