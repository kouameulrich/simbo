
class RecensementDto {
  String? dateRecensement;
  String? sigleTypeEquipement; //sigle de TypeEquipement
  String? nomCommercial;
  String? secteurCode; // code du Secteur
  String? activiteCommerciale; // type de TypeActiviteCommerciale
  String? localisation;
  String? numeroDePorte;
  String? nom; // nom contribuable
  String? prenom; // prenom contribuable
  String? typePersonne; // enumeration PHYSIQUE ou MORALE
  String? sexe; //enumeration F ou M
  String? nomSociete;
  String? email;
  String? telephone;
  String? infosComplementaires;
  String? matriculeAgent; // matricule agent connecté
  bool? estValide; // false

  @override
  String toString() {
    return 'Recensement{'
        ' dateRecensement: $dateRecensement,'
        ' sigleTypeEquipement: $sigleTypeEquipement, '
        'nomCommercial: $nomCommercial,'
        ' secteurCode: $secteurCode,'
        ' activiteCommerciale: $activiteCommerciale,'
        ' localisation: $localisation,'
        ' numeroDePorte: $numeroDePorte,'
        ' nom: $nom, prenom: $prenom,'
        ' typePersonne: $typePersonne,'
        ' sexe: $sexe,'
        ' nomSociete: $nomSociete,'
        ' email: $email,'
        ' telephone: $telephone,'
        ' infosComplementaires: $infosComplementaires,'
        ' matriculeAgent: $matriculeAgent,'
        ' estValide: $estValide}';
  }



  RecensementDto(
      {
        this.dateRecensement,
        this.sigleTypeEquipement,
        this.nomCommercial,
        this.secteurCode,
        this.activiteCommerciale,
        this.localisation,
        this.numeroDePorte,
        this.nom,
        this.prenom,
        this.typePersonne,
        this.sexe,
        this.nomSociete,
        this.email,
        this.telephone,
        this.infosComplementaires,
        this.matriculeAgent,
        this.estValide,
      });

  RecensementDto.fromJson(Map<String, dynamic> json) {

    dateRecensement = json['dateRecensement'];
    sigleTypeEquipement = json['sigleTypeEquipement'];
    nomCommercial = json['nomCommercial'];
    secteurCode = json['secteurCode'];
    activiteCommerciale = json['activiteCommerciale'];
    localisation = json['localisation'];
    numeroDePorte = json['numeroDePorte'];
    nom = json['nom'];
    prenom = json['prenom'];
    typePersonne = json['typePersonne'];
    sexe = json['sexe'];
    nomSociete = json['nomSociete'];
    email = json['email'];
    telephone = json['telephone'];
    infosComplementaires = json['infosComplementaires'];
    matriculeAgent = json['matriculeAgent'];
    estValide = json['estValide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateRecensement'] = dateRecensement;
    data['sigleTypeEquipement'] = sigleTypeEquipement;
    data['nomCommercial'] = nomCommercial;
    data['secteurCode'] = secteurCode;
    data['activiteCommerciale'] = activiteCommerciale;
    data['localisation'] = localisation;
    data['numeroDePorte'] = numeroDePorte;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['typePersonne'] = typePersonne;
    data['sexe'] = sexe;
    data['nomS3ociete'] = nomSociete;
    data['email'] = email;
    data['telephone'] = telephone;
    data['infosComplementaires'] = infosComplementaires;
    data['matriculeAgent'] = matriculeAgent;
    data['estValide'] = estValide;
    return data;
  }
}
