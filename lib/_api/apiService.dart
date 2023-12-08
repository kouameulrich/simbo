
import 'dart:convert';
import 'dart:math';


import 'package:dio/dio.dart';
import 'package:simbo_mobile/_api/dioClient.dart';
import 'package:simbo_mobile/_api/endpoints.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/TypeActiviteCommerciale.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/dto/facture.dto.dart';
import 'package:simbo_mobile/models/dto/recensement.dto.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';


class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

Future<List<TypeEquipement>> getAllTypeEquipemnts() async{
  // try{
    final  response = await _dioClient.get(Endpoints.typeEquipements);
    List<TypeEquipement> equipmentTypes = (response.data as List)
        .map((e) => TypeEquipement.fromJson(e))
        .toList();
    return equipmentTypes;
  // } on DioError catch (e) {
  //   final errorMessage = DioExceptions.fromDioError(e).toString();
  //   throw errorMessage;
  // }
}

  Future<List<Secteur>> getAllSecteurs() async{
    // try{
      final  response = await _dioClient.get(Endpoints.secteurs);
      List<Secteur> sectors = (response.data as List)
          .map((e) => Secteur.fromJson(e))
          .toList();
      return sectors;
    // } on DioError catch (e) {
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   throw errorMessage;
    // }
  }

  Future<List<TypeActiviteCommerciale>> getAllTypeActiviteCommerciale() async{
    // try{
      final  response = await _dioClient.get(Endpoints.activiteCommerciales);
      List<TypeActiviteCommerciale> activities = (response.data as List)
          .map((e) => TypeActiviteCommerciale.fromJson(e))
          .toList();
      return activities;
    // } on DioError catch (e) {
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   throw errorMessage;
    // }
  }

  Future<Agent> getUserConnected(String username) async{
  String agentEndpoint = '/agents/$username/slim/byusername';
   // try{
      final  response = await _dioClient.get(agentEndpoint);
      return  Agent.fromJson(response.data);
    // } on DioError catch (e) {
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   throw errorMessage;
    // }
  }

  Future<Collectivite> getCollectivite(String code) async{
    String collectiviteEndpoint = '/collectivites/$code/bycode';
    final  response = await _dioClient.get(collectiviteEndpoint);
    return  Collectivite.fromJson(response.data);
  }
  Future<void> sendRecensement(List<Recensement> recensements) async{
  final resensementJson = convertRecencementToRecensementDto(recensements).map((e) => e.toJson()).toList();
    // try{
  print(json.encode(resensementJson));
       await _dioClient.post(Endpoints.recensements, data: json.encode(resensementJson));
    // } on DioError catch (e) {
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   throw errorMessage;
    // }
  }

   List<RecensementDto> convertRecencementToRecensementDto( List<Recensement> recensements){
  List<RecensementDto> recensementDto = [];
  for (var r in recensements) {
    RecensementDto r1 = RecensementDto(
        matriculeAgent: r.matriculeAgent,
        localisation: r.localisation,
        estValide: r.estValide == 0 ? false : true,
        dateRecensement: r.dateRecensement!.substring(0,10),
        infosComplementaires: r.infosComplementaires,
        email: r.email,
        telephone: r.telephone,
        nomSociete: r.nomSociete,
        sexe: r.sexe == 'Feminin' ? 'F' : 'M',
        typePersonne: r.typePersonne,
        prenom: r.prenom,
        nom: r.nom,
        numeroDePorte: r.numeroDePorte,
        nomCommercial: r.nomCommercial,
        secteurCode: r.secteurCode,
        activiteCommerciale: r.activiteCommerciale,
        sigleTypeEquipement: r.sigleTypeEquipement
     );
    recensementDto.add(r1);
  }
  return recensementDto;
  }

  Future<List<Facture>> getFactureImpayeFromAgent(String agentMatricule) async{
    String factureImpayeEndpoint = '/agents/$agentMatricule/factures/impayes';
    final  response = await _dioClient.get(factureImpayeEndpoint);
    List<Facture> factures = (response.data as List)
        .map((e) => Facture.fromJson(e))
        .toList();
    return factures;
  }

  Future<void> sendCollecte(List<Facture> factures, String matriculeagent) async{
    final factureJson = convertFactureToFactureDto(factures,matriculeagent).map((e) => e.toJson()).toList();
    print(json.encode(factureJson));
    await _dioClient.post(Endpoints.paiementFactures, data: json.encode(factureJson));

  }
  List<Facturedto> convertFactureToFactureDto( List<Facture> factures, String matriculeagent){
    List<Facturedto> facturedtos = [];
    for (var f in factures) {
      Facturedto f1 = Facturedto(
          id: f.id,
          numeroFacture: f.numeroFacture,
          montantPaye: f.montantPaye,
          numeroCompte: f.numeroCompte,
          matriculeEquipement: f.matriculeEquipement,
          matriculeAgent: matriculeagent,
          recuPaiement: f.recuPaiement,
      );
      facturedtos.add(f1);
    }
    return facturedtos;
  }
}