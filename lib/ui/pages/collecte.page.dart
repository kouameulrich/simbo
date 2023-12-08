import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simbo_mobile/_api/apiService.dart';
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/misc/printer.service.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/ui/pages/payment.page.dart';
import 'package:simbo_mobile/ui/pages/printing.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/mydrawer.dart';
import 'package:pdf/widgets.dart' as pw;

class CollectePage extends StatefulWidget {
  const CollectePage({Key? key}) : super(key: key);

  @override
  State<CollectePage> createState() => _CollectePageState();
}

class _CollectePageState extends State<CollectePage> {
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  final printerService = locator<PrinterService>();
  late final Future<Agent?> _futureAgentConnected;
  String? matricule;
  Agent? agentConnected;
  Collectivite? collectiviteConnected;
  Facture? facture;
  List<Facture> _factures = [];
  List<Collectivite> _collectivite = [];
  late final Future<Collectivite?> _futureCollectiviteConnected;
  int _countFacture = 0;
  int _countFacturePaye = 0;
  List<String> etatFactureMobile = [
    'MOBILE_REGLEE',
    'MOBILE_REGLEMENT_PARTIEL'
  ];
  TextEditingController searchController = TextEditingController();

  Future<List<Facture>> getAllFacture() async {
    return await dbHandler.readFactureImpayeFromAgent();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  Future<Collectivite?> getCollectivite() async {
    return await storage.retrieveCollectiviteConnected();
  }

  @override
  void initState() {
    print('initstate');
    _futureAgentConnected = getAgent();
    _futureCollectiviteConnected = getCollectivite();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      print('Postconstruct');
      getAllFacture().then((value) => setState(() {
            _countFacture = value!.length;
            _factures = value;
            _countFacturePaye = value
                .where((element) =>
                    etatFactureMobile.contains(element.etatFacture))
                .toList()
                .length;
          }));
      getAgent().then((value) => setState(() {
        agentConnected = value;
      }));

      getCollectivite().then((value) => setState(() {
        collectiviteConnected = value;
      }));
    });
  }

  @override
  void dispose() {
    print('dispose');
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Collecte'),
            Text(
              '$_countFacturePaye/$_countFacture',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      floatingActionButton: _countFacturePaye == 0
          ? const Text('')
          : FloatingActionButton(
              backgroundColor: Defaults.greenPrincipal,
              foregroundColor: Colors.white,
              onPressed: () async {

              },
              child: const Icon(Icons.print),
            ),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 15, bottom: 15),
              child: _countFacture == 0
                  ? const Text('')
                  : TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Recherche',
                      ),
                      onChanged: (value) {
                        setState(() {
                          getAllFacture().then((factures) => {
                                _factures = factures
                                    .where((element) =>
                                        element.telephoneContribuable!.contains(
                                            searchController.text.toString()) ||
                                        element.nomContribuable!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.prenomContribuable!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.matriculeContribuable!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.numeroFacture!
                                            .toLowerCase()
                                            .contains(
                                                searchController.text.toString().toLowerCase()))
                                    .toList()
                              });
                        });
                      },
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTileTheme(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListView.separated(
                      itemCount: _factures.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white,
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          margin: EdgeInsets.all(0.0),
                          //color: Defaults.greenSelected,
                          child: ListTile(
                            leading: const CircleAvatar(
                              //backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_factures![index].nomContribuable} ${_factures![index].prenomContribuable}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                Text(
                                    '${_factures![index].matriculeContribuable} - ${_factures![index].telephoneContribuable}'),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${_factures![index].numeroFacture} - ${NumberFormat.currency(decimalDigits: 0, name: '').format(_factures![index].resteAPayer)}'),
                              ],
                            ),
                            onTap: () {
                              if (_factures![index].etatFacture !=
                                  'MOBILE_REGLEE') {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PaymentPage(
                                            facture: _factures![index])));
                              }
                            },
                            trailing: (_factures![index].etatFacture ==
                                        'MOBILE_REGLEE' ||
                                    _factures![index].etatFacture ==
                                        'MOBILE_REGLEMENT_PARTIEL')
                                ? IconButton(
                                    ///---------- IMPRESSION -----------/////
                                    onPressed: () async {
                                      pw.Document  docPage1 = await printerService.printFacture(_factures![index], agentConnected!, collectiviteConnected!);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrintingPage(docPage: docPage1),
                                          ));
                                    },
                                    icon: const Icon(
                                      Icons.print,
                                      color: Defaults.greenPrincipal,
                                    ))
                                : const Text(''),
                          ),
                        );
                      },
                    )
                    //}),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
