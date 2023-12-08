
class Collectivite {
  int? id;
  String? nom;
  String? pseudo;
  String? code;
  String? compteContribuable;
  String? sigle;
  String? reference;
  String? telephone;
  String? adresse;
  String? localisation;
  String? logo;
  String? siteWeb;
  String? email;

  Collectivite({
      this.id,
      this.nom,
      this.pseudo,
      this.code,
      this.compteContribuable,
      this.sigle,
      this.reference,
      this.telephone,
      this.adresse,
      this.localisation,
      this.logo,
      this.siteWeb,
      this.email});

  @override
  String toString() {
    return 'Collectivite{id: $id, nom: $nom, pseudo: $pseudo, code: $code, compteContribuable: $compteContribuable, sigle: $sigle, reference: $reference, telephone: $telephone, adresse: $adresse, localisation: $localisation, logo: $logo, siteWeb: $siteWeb, email: $email}';
  }

  Collectivite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    pseudo = json['pseudo'];
    code = json['code'];
    compteContribuable = json['compteContribuable'];
    sigle = json['sigle'];
    reference = json['reference'];
    telephone = json['telephone'];
    adresse = json['adresse'];
    localisation = json['localisation'];
    logo = json['logo'];
    siteWeb = json['siteWeb'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['pseudo'] = pseudo;
    data['code'] = code;
    data['compteContribuable'] = compteContribuable;
    data['sigle'] = sigle;
    data['reference'] = reference;
    data['telephone'] = telephone;
    data['adresse'] = adresse;
    data['localisation'] = localisation;
    data['logo'] = logo;
    data['siteWeb'] = siteWeb;
    data['email'] = email;
    return data;
  }
}