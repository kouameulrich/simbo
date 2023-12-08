import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'simbo.db'),
      onCreate: (database, version) async {
       /* await database.execute(
            'CREATE TABLE recensement (id INTEGER PRIMARY KEY, dateRecensement TEXT, sigleTypeEquipement TEXT, nomCommercial TEXT, secteurCode TEXT, activiteCommeciale TEXT, localisation TEXT, numeroDePorte TEXT, nom TEXT, prenom TEXT, typePersonne TEXT, sexe TEXT, nomsociete TEXT, email TEXT, telephone TEXT, infosComplementaires TEXT, matriculeAgent TEXT, estValide BOOL);'
        );*/
        await database.execute('CREATE TABLE secteur (id INTEGER PRIMARY KEY, designation TEXT, description TEXT, code TEXT, sigle TEXT, collectiviteCode TEXT);');
      },
      version: 1,
    );
  }


  Future<void> insertSecteur(Secteur secteur) async {
    final db = await initializeDB();
    await db.insert(
      'secteur',
      conflictAlgorithm: ConflictAlgorithm.replace,
      secteur.toJson(),
    );
  }

  Future<void> deleteRecensement(int id) async {
    final db = await initializeDB();
    await db.delete(
      'Recensement',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Secteur>> ListAllSecteurs() async {
    final db = await initializeDB();
    List<Map<String, dynamic>> queryResult = await db.query('secteur');
    return queryResult.map((e) => Secteur.fromJson(e)).toList();
  }

}

