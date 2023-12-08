
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';

import '../models/tokenModel.dart';


class TokenStorageService{
  // Create storage
   final FlutterSecureStorage _storage;
   static const String TOKEN_KEY = "TOKEN";
   static const String TENANT_KEY = "TENANT_ID";
   static const String USER_KEY = "USER";
   static const String MAT_KEY = "MAT";
   static const String USERNAME_KEY = "USERNAME";
   static const String NOM_KEY = "NOM";
   static const String NOMCOLLECTIVITE_KEY = "NOMCOLLECTIVITE";
   static const String PRENOM_KEY = "PRENOM";
   static const String COMPTECONTRIBUABLE_KEY = "COMPTECONTRIBUABLE";
   static const String REFERENCE_KEY = "REFERENCE";
   static const String TELEPHONE_KEY = "TELEPHONE";
   static const String ADRESSE_KEY = "ADRESSE";

   TokenStorageService(this._storage);

   void saveToken(String token) async {
    await _storage.write(key: TOKEN_KEY, value: token);
  }
   void saveTenantId(String tenant) async {
     await _storage.write(key: TENANT_KEY, value: tenant);
   }

   void saveAgentConnected(Agent agent) async {
     await _storage.write(key: MAT_KEY, value: agent.matricule);
     await _storage.write(key: USERNAME_KEY, value: agent.nomUtilisateur);
     await _storage.write(key: NOM_KEY, value: agent.nom);
     await _storage.write(key: PRENOM_KEY, value: agent.prenom);
   }

   void saveCollectiviteConnected(Collectivite collectivite) async {
     await _storage.write(key: NOMCOLLECTIVITE_KEY, value: collectivite.nom);
     await _storage.write(key: COMPTECONTRIBUABLE_KEY, value: collectivite.compteContribuable);
     await _storage.write(key: REFERENCE_KEY, value: collectivite.reference);
     await _storage.write(key: TELEPHONE_KEY, value: collectivite.telephone);
     await _storage.write(key: ADRESSE_KEY, value: collectivite.adresse);
   }

   Future<Agent?> retrieveAgentConnected() async {
     String? matricule = await _storage.read(key: MAT_KEY);
     String? username = await _storage.read(key: USERNAME_KEY);
     String? nomagent = await _storage.read(key: NOM_KEY);
     String? prenom = await _storage.read(key: PRENOM_KEY);
     Agent agentConnected = Agent(matricule: matricule,nomUtilisateur: username,nom: nomagent,prenom: prenom);
     return agentConnected;
   }

   Future<Collectivite?> retrieveCollectiviteConnected() async {
     String? nomcollectivite = await _storage.read(key: NOMCOLLECTIVITE_KEY);
     String? compteContribuable = await _storage.read(key: COMPTECONTRIBUABLE_KEY);
     String? reference = await _storage.read(key: REFERENCE_KEY);
     String? telephone = await _storage.read(key: TELEPHONE_KEY);
     String? adresse = await _storage.read(key: ADRESSE_KEY);
     Collectivite collectiviteConnected = Collectivite(nom: nomcollectivite, compteContribuable: compteContribuable, telephone: telephone, reference: reference, adresse: adresse);
     return collectiviteConnected;
   }

   Future<String?> retrieveTenant() async {
     String? tenant = await _storage.read(key: TENANT_KEY);
     if (tenant == null) {
       return null;
     }
     return tenant;
   }

  Future<String?> retrieveAccessToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).accessToken;
  }

  Future<String?> retrieveRefreshToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).refreshToken;
  }
  Future<bool> isTokenExist() async {
   return await _storage.containsKey(key: TOKEN_KEY);
  }
  Future<void> deleteAllToken() async {
    _storage.deleteAll();
  }
  deleteToken(String tokenKey){
    _storage.delete(key: tokenKey);
  }
}