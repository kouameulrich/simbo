
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseConnection{
  Future<Database> setDatabase() async {
    //var directory = await getApplicationDocumentsDirectory();
    //var path = join(directory.path, 'db_crud');
    var path = join(await getDatabasesPath(), 'db_crud');
    await deleteDatabase(path);
    var database = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }
  Future<void> _createDatabase(Database database, int version) async {
    String sqlSecteur= "CREATE TABLE secteur (id INTEGER PRIMARY KEY, designation TEXT, description TEXT, code TEXT, sigle TEXT, collectiviteCode TEXT);";
    String sqlTypeEquipement= "CREATE TABLE typeequipement (id INTEGER PRIMARY KEY, libelle TEXT, sigle TEXT);";
    String sqlTypeActivite= "CREATE TABLE typeactivitecommerciale (id INTEGER PRIMARY KEY, type TEXT, description TEXT);";
    String sqlRecensement = "CREATE TABLE recensement (id INTEGER PRIMARY KEY, dateRecensement TEXT, sigleTypeEquipement TEXT, nomCommercial TEXT, secteurCode TEXT, activiteCommerciale TEXT, localisation TEXT, numeroDePorte TEXT, nom TEXT, prenom TEXT, typePersonne TEXT, sexe TEXT, nomSociete TEXT, email TEXT, telephone TEXT, infosComplementaires TEXT, matriculeAgent TEXT, estValide BOOLEAN);";
    String sqlFacture = "CREATE TABLE facture (id INTEGER PRIMARY KEY, numeroFacture TEXT, dateEdition TEXT, montantApayer REAL, montantAnterieurDu REAL, montantPaye REAL, resteAPayer REAL, etatFacture TEXT, dateLimitePaiement TEXT, periodiciteTaxe TEXT, numeroCompte TEXT, matriculeContribuable TEXT, nomContribuable TEXT, prenomContribuable TEXT, telephoneContribuable TEXT, matriculeEquipement TEXT, recuPaiement TEXT, dateOperation TEXT);";
    await database.execute(sqlSecteur);
    await database.execute(sqlTypeEquipement);
    await database.execute(sqlTypeActivite);
    await database.execute(sqlRecensement);
    await database.execute(sqlFacture);
  }
}