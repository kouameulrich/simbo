import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHandler = locator<LocalService>();

  int equipemntNumber = 0;
  int femaleNumber = 0;
  int maleNumber = 0;
  int moralNumber = 0;
  int physicNumber = 0;
  int _secteursConcernes = 0;
  List<String> secteursCode = [];
  List<Facture> _facturesPayees = [];
  List<Facture> _factures = [];
  int _countFacture = 0;
  int _countFacturePaye = 0;
  double _montantCollecte = 0.0;

  List<String> etatFactureMobile = [
    'MOBILE_REGLEE',
    'MOBILE_REGLEMENT_PARTIEL'
  ];

  double _montantTotalFacture = 0.0;

  double _montantCollectePartielle = 0.0;

  double _montantCollecteTotale = 0.0;

  int _countCollectePartielle = 0;

  int _countCollecteTotale = 0;

  double _montantRestant = 0.0;

  Future<List<Recensement>> getAllRecensement() async {
    return await dbHandler.readAllRecensement();
  }

  Future<List<Secteur>> getAllSecteurs() async {
    return await dbHandler.readAllSecteurs();
  }

  Future<List<Facture>> getAllFacture() async {
    return await dbHandler.readFactureImpayeFromAgent();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getAllSecteurs().then((value) =>
      {secteursCode = value.map((e) => e.designation!).toList()});

      getAllRecensement().then((value) => setState(() {
        equipemntNumber = value!.length;
        maleNumber = value
            .where((element) => element.sexe == 'Masculin')
            .toList()
            .length;
        femaleNumber = value
            .where((element) => element.sexe == 'Feminin')
            .toList()
            .length;
        physicNumber = value
            .where((element) => element.typePersonne == 'PHYSIQUE')
            .toList()
            .length;
        moralNumber = value
            .where((element) => element.typePersonne == 'MORALE')
            .toList()
            .length;
        _secteursConcernes = value
            .where((element) => secteursCode.contains(element.secteurCode))
            .toList()
            .length;
      }));
      getAllFacture().then((value) => setState(() {
        _factures = value;

        _countFacture = _factures.length;

        _montantTotalFacture = value.fold(
            0, (value, element) => value.toDouble() + element.resteAPayer!);

        _facturesPayees = value
            .where((element) =>
            etatFactureMobile.contains(element.etatFacture))
            .toList();
        _countFacturePaye = _facturesPayees.length;

        _countCollectePartielle = value
            .where((element) =>
        element.etatFacture == 'MOBILE_REGLEMENT_PARTIEL')
            .toList()
            .length;

        _montantCollectePartielle = value
            .where((element) =>
        element.etatFacture == 'MOBILE_REGLEMENT_PARTIEL')
            .toList()
            .fold(
            0,
                (value, element) =>
            value.toDouble() + element.montantPaye!);

        _countCollecteTotale = value
            .where((element) => element.etatFacture == 'MOBILE_REGLEE')
            .toList()
            .length;

        _montantCollecteTotale = value
            .where((element) => element.etatFacture == 'MOBILE_REGLEE')
            .toList()
            .fold(
            0,
                (value, element) =>
            value.toDouble() + element.montantPaye!);

        _montantCollecte = value
            .where((element) =>
            etatFactureMobile.contains(element.etatFacture))
            .toList()
            .fold(
            0,
                (value, element) =>
            value.toDouble() + element.montantPaye!);

        _montantRestant = _montantTotalFacture - _montantCollecte;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Defaults.blueFondCadre,
        appBar: AppBar(
          title: const Text('Accueil'),
          bottom: const TabBar(
            indicatorColor: Defaults.greenSelected,
            //indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Recensement'),
              Tab(icon: Icon(Icons.monetization_on), text: 'Collecte'),
            ],
          ),
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$equipemntNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Equipements',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'recensés',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_secteursConcernes',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Secteurs',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'concernés',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$femaleNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Contribuables',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'féminin',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$maleNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Contribuables',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'masculin',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$moralNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Personne',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'morale',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$physicNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Personne',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'physique',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_countFacture',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Factures à ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'recouvrir',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_montantTotalFacture),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Montant facture ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'à recouvrir',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_countCollectePartielle),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Collecte partielle ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'effectuée',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_montantCollectePartielle),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Montant collecte ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'partielle',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_countCollecteTotale),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Collecte totale',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'effectuée',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_montantCollecteTotale),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Montant totale',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'effectuée',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_montantRestant),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Montant total',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'restant',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     offset: Offset(
                          //       5.0,
                          //       5.0,
                          //     ), //Offset
                          //     blurRadius: 5.0,
                          //     spreadRadius: 2.0,
                          //   ), //BoxShadow
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   ), //BoxShadow
                          // ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                    decimalDigits: 0, name: '')
                                    .format(_montantCollecte),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Totale collecte',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'effectuée',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
