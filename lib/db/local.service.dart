

import 'package:simbo_mobile/db/repository.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/TypeActiviteCommerciale.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';

class LocalService{
  final Repository _repository;

  LocalService(this._repository);
// Secteur
  //Save Secteur
  SaveSecteur(Secteur secteur) async{
    return await _repository.insertData('secteur', secteur.toJson());
  }
  //Read All Secteurs
  Future<List<Secteur>> readAllSecteurs() async{
    List<Secteur> secteurs = [];
    List<Map<String,dynamic>> list= await _repository.readData('secteur');
    for (var secteur in list) {
      secteurs.add(Secteur.fromJson(secteur));
    }
    return secteurs;
  }
  //Edit Secteur
  UpdateSecteur(Secteur secteur) async{
    return await _repository.updateData('secteur', secteur.toJson());
  }
  // delete secteur
  deleteSecteur(secteurId) async {
    return await _repository.deleteDataById('secteur', secteurId);
  }

  // TypeEquipement

  SaveTypeEquipement(TypeEquipement type) async{
    return await _repository.insertData('typeequipement', type.toJson());
  }

  Future<List<TypeEquipement>> readAllTypeEquipements() async{
    List<TypeEquipement> types = [];
    List<Map<String,dynamic>> list= await _repository.readData('typeequipement');
    for (var type in list) {
      types.add(TypeEquipement.fromJson(type));
    }
    return types;
  }

  UpdateTypeEquipement(TypeEquipement typeEquipement) async{
    return await _repository.updateData('typeequipement', typeEquipement.toJson());
  }

  deleteTypeEquipement(typeId) async {
    return await _repository.deleteDataById('typeequipement', typeId);
  }

  // TypeAtiviteCommerciale

  SaveTypeActivite(TypeActiviteCommerciale type) async{
    return await _repository.insertData('typeactivitecommerciale', type.toJson());
  }

  Future<List<TypeActiviteCommerciale>> readAllTypeActivites() async{
    List<TypeActiviteCommerciale> types = [];
    List<Map<String,dynamic>> list= await _repository.readData('typeactivitecommerciale');
    for (var type in list) {
      types.add(TypeActiviteCommerciale.fromJson(type));
    }
    return types;
  }

  UpdateTypeActivite(TypeActiviteCommerciale typeActivite) async{
    return await _repository.updateData('typeactivitecommerciale', typeActivite.toJson());
  }

  deleteTypeActivite(typeId) async {
    return await _repository.deleteDataById('typeactivitecommerciale', typeId);
  }

  // Recensement

  //Save Recensement
  SaveRecensement(Recensement recensement) async {
    return await _repository.insertData('recensement', recensement.toJson());
  }

  //Read All Recensement
  Future<List<Recensement>> readAllRecensement() async{
    List<Recensement> recensements = [];
    List<Map<String,dynamic>> list= await _repository.readData('recensement');
    for (var recensement in list) {
      recensements.add(Recensement.fromJson(recensement));
    }
    return recensements;
  }

  //Edit Recensement
  UpdateRecensement(Recensement recensement) async{
    return await _repository.updateData('recensement', recensement.toJson());
  }

  // delete Recensement
  deleteRecensement(recensementId) async {
    return await _repository.deleteDataById('recensement', recensementId);
  }

  //read facture to pay
  Future<List<Facture>> readFactureImpayeFromAgent() async {
    List<Facture> factures = [];
    List<Map<String,dynamic>> list= await _repository.readData('facture');
    for (var facture in list) {
      factures.add(Facture.fromJson(facture));
    }
    return factures;
  }
  //read facture by id
  Future<Facture> readFactureById(int factureid) async {
    return await _repository.readDataById('facture', factureid);
  }
  //Save Facture
  SaveFacture(Facture facture) async {
    return await _repository.insertData('facture', facture.toJson());
  }

  // delete Facture
  deleteFacture(factureId) async {
    return await _repository.deleteDataById('facture', factureId);
  }

  // update Facture
  updateFacture(facture) async{
    return await _repository.updateData('facture', facture);
  }

  //Collectivite
  Future<List<Collectivite>> readAllCollectivite() async{
    List<Collectivite> collectivites = [];
    List<Map<String,dynamic>> list= await _repository.readData('collectivite');
    for (var collectivite in list) {
      collectivites.add(Collectivite.fromJson(collectivite));
    }
    return collectivites;
  }
}