import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simbo_mobile/_api/apiService.dart';
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/error.dialog.dart';
import 'package:simbo_mobile/widgets/loading.indicator.dart';
import 'package:simbo_mobile/widgets/mydrawer.dart';

import '../../models/agent.dart';

class TransfertDonnees extends StatefulWidget {
  const TransfertDonnees({Key? key}) : super(key: key);

  @override
  State<TransfertDonnees> createState() => _TransfertDonneesState();
}

class _TransfertDonneesState extends State<TransfertDonnees> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final _storage = locator<TokenStorageService>();
  List<Recensement> _recensements = [];
  List<Facture> _facturesPayees = [];
  List<Facture> _factures = [];
  List<TypeEquipement> _typeEquipements = [];
  List<Secteur> _secteurs = [];
  List<String> etatFactureMobile = [
    'MOBILE_REGLEE',
    'MOBILE_REGLEMENT_PARTIEL'
  ];
  int _countFacturePaye = 0;
  double _montantCollecte = 0.0;
  String? _matriculeAgent;
  Future<List<Recensement>> getAllRecensement() async {
    return await dbHandler.readAllRecensement();
  }

  Future<List<TypeEquipement>> getAllTypeEquipement() async {
    return await dbHandler.readAllTypeEquipements();
  }

  Future<List<Secteur>> getAllSecteurs() async {
    return await dbHandler.readAllSecteurs();
  }

  Future<List<Facture>> getAllFacture() async {
    return await dbHandler.readFactureImpayeFromAgent();
  }

  Future<Agent?> getAgentConnected() async {
    return await _storage.retrieveAgentConnected();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      getAgentConnected().then((value) => setState(() {
            _matriculeAgent = value!.matricule;
          }));
      getAllTypeEquipement().then((typeequipements) => {
            _typeEquipements = typeequipements,
          });
      getAllSecteurs().then((secteurs) => {_secteurs = secteurs});
      getAllRecensement().then((value) => {
            setState(() {
              // change typeequipement libelle to sigle
              // change secteur designation to code
              for (var recensement in value) {
                _typeEquipements
                    .where((element) =>
                        element.libelle == recensement.sigleTypeEquipement)
                    .map((e) => recensement.sigleTypeEquipement = e.sigle)!
                    .first;

                _secteurs
                    .where((element) =>
                        element.designation == recensement.secteurCode)
                    .map((e) => recensement.secteurCode = e.code)!
                    .first;
              }
              _recensements = value;
            })
          });

      getAllFacture().then((value) => {
            setState(() {
              _factures = value;
              _facturesPayees = value
                  .where((element) =>
                      etatFactureMobile.contains(element.etatFacture))
                  .toList();
              _countFacturePaye = _facturesPayees.length;
              _montantCollecte = value
                  .where((element) =>
                      etatFactureMobile.contains(element.etatFacture))
                  .toList()
                  .fold(
                      0,
                      (value, element) =>
                          value.toDouble() + element.montantPaye!);
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        title: const Text('Transfert'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Card(
                //color: Defaults.blueFondCadre,
                elevation: 10,
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Recensements",
                          style: TextStyle(
                              fontSize: 20,
                              color: Defaults.bluePrincipal,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.blueFondCadre,
                            ),
                            child: Text('${_recensements.length}',
                                style: const TextStyle(
                                    fontSize: 75,
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.bluePrincipal))),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 250,
                            child: ElevatedButton(
                                onPressed: () =>
                                    _transferRecensementsToServer(),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Defaults.primaryGreenColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.send),
                                      Text(
                                        'Transferer',
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Card(
                // color: Defaults.blueFondCadre,
                elevation: 10,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Collectes",
                          style: TextStyle(
                              fontSize: 20,
                              color: Defaults.bluePrincipal,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Defaults.blueFondCadre,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Nombre: $_countFacturePaye',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Defaults.bluePrincipal)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    NumberFormat.currency(
                                            decimalDigits: 0, name: '')
                                        .format(_montantCollecte),
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Defaults.bluePrincipal)),
                                const Text(
                                  'FRCFA',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.greenSelected),
                                ),
                                const Text(
                                  'Montant Collecté',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 250,
                            child: ElevatedButton(
                                onPressed: () => _transferCollecteToServer(),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Defaults.primaryGreenColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.send),
                                      Text(
                                        'Transferer',
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _transferRecensementsToServer() {
    if (_recensements.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation',
                  style: TextStyle(color: Defaults.primaryBleuColor)),
              content: const Text(
                  'Voulez-vous transferer les recensements vers le serveur?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        LoadingIndicatorDialog().show(context);
                        print(_recensements.toString());
                        await apiService.sendRecensement(_recensements);
                        //delete local data after transfering
                        for (var recensement in _recensements) {
                          dbHandler.deleteRecensement(recensement.id);
                        }
                        getAllRecensement().then((value) => setState(() {
                              _recensements = value;
                            }));
                        LoadingIndicatorDialog().dismiss();
                      } on DioError catch (e) {
                        LoadingIndicatorDialog().dismiss();
                        ErrorDialog().show(e);
                        //print(e.message);
                      }
                    },
                    child: const Text('Oui'))
              ],
            );
          });
    }
  }

  _transferCollecteToServer() {
    if (_facturesPayees.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation',
                  style: TextStyle(color: Defaults.primaryBleuColor)),
              content: const Text(
                  'Voulez-vous transferer les collectes vers le serveur?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        LoadingIndicatorDialog().show(context);
                        print(_facturesPayees.toString());
                        await apiService.sendCollecte(
                            _facturesPayees, _matriculeAgent!);
                        //delete local data after transfering
                        for (var facture in _factures) {
                          dbHandler.deleteFacture(facture.id);
                        }
                        getAllFacture().then((value) => setState(() {
                              _facturesPayees = value
                                  .where((element) => etatFactureMobile
                                      .contains(element.etatFacture))
                                  .toList();
                              _countFacturePaye = _facturesPayees.length;

                              _montantCollecte = value
                                  .where((element) => etatFactureMobile
                                      .contains(element.etatFacture))
                                  .toList()
                                  .fold(
                                      0,
                                      (value, element) =>
                                          value.toDouble() +
                                          element.montantPaye!);
                            }));
                        LoadingIndicatorDialog().dismiss();
                      } on DioError catch (e) {
                        LoadingIndicatorDialog().dismiss();
                        ErrorDialog().show(e);
                        //print(e.message);
                      }
                    },
                    child: const Text('Oui'))
              ],
            );
          });
    }
  }
}
