import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simbo_mobile/_api/apiService.dart';
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/misc/printer.service.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/ui/pages/collecte.page.dart';
import 'package:simbo_mobile/ui/pages/printing.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:pdf/widgets.dart' as pw;

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key, required this.facture}) : super(key: key);

  final Facture facture;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  final printerService = locator<PrinterService>();
  Agent? agentConnected;
  Collectivite? collectiviteConnected;
  String? matricule;
  List<String> etatFactureMobile = [
    'MOBILE_REGLEE',
    'MOBILE_REGLEMENT_PARTIEL'
  ];

  TextEditingController montantverseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      print('Postconstruct');
      getAllFacture().then((value) => setState(() {
          }));
    });
  }

  @override
  void dispose() {
    montantverseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Paiement facture'),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CollectePage()));
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        centerTitle: true,
      ),
      // drawer: MyDrawer(),
      backgroundColor: Defaults.blueFondCadre,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contribuable',
                        style: TextStyle(
                            color: Defaults.bluePrincipal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Nom et prenom: ${widget.facture.nomContribuable} ${widget.facture.prenomContribuable}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Matricule: ${widget.facture.matriculeContribuable}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Contact:  ${widget.facture.telephoneContribuable} '),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Facture N°:  ${widget.facture.numeroFacture} '),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Equipement',
                        style: TextStyle(
                            color: Defaults.bluePrincipal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Matricule: ${widget.facture.matriculeEquipement}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Taxe: ${NumberFormat.currency(decimalDigits: 0, name: '').format(widget.facture.montantApayer)} / ${widget.facture.periodiciteTaxe}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Montant Anterieur du:  ${NumberFormat.currency(decimalDigits: 0, name: '').format(widget.facture.montantAnterieurDu)} '),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Montant Anterieur payé:  ${NumberFormat.currency(decimalDigits: 0, name: '').format(widget.facture.montantPaye)} '),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 15, bottom: 15),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: ListTile(
                          title: Column(
                            children: [
                              Center(
                                  child: Text(
                                NumberFormat.currency(
                                        decimalDigits: 0, name: '')
                                    .format(widget.facture.resteAPayer),
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.bluePrincipal),
                              )),
                              const Center(
                                  child: Text(
                                'FRCFA',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.greenPrincipal),
                              )),
                            ],
                          ),
                          subtitle: const Center(
                              child: Text(
                            'Montant a payer',
                            style: TextStyle(
                                fontSize: 20, color: Defaults.bluePrincipal),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 15, bottom: 15),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: montantverseController,
                      keyboardType: TextInputType.number,
                      // inputFormatters: [ThousandsFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer un montant';
                        } else if (double.parse(value) >
                            double.parse(
                                widget.facture.resteAPayer.toString())) {
                          return 'Entrer un montant inferieur ou égal à ${widget.facture.resteAPayer}';
                        } else if (double.parse(value) < 100) {
                          return 'Entrer un montant superieur ou égal à 100';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Montant collecté',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 15, bottom: 15),
                  child: ElevatedButton(
                      onPressed: () async {
                        onSubmit();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Defaults.primaryGreenColor)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.monetization_on),
                            Text(
                              'Payer',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Confirmation',
                style: TextStyle(color: Defaults.bluePrincipal),
              ),
              content: const Text('Voulez-vous payer cette facture?'),
              actions: [
                TextButton(
                    child: const Text('Non'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    onPressed: () async {
                      widget.facture.montantPaye =
                          double.parse(widget.facture.montantPaye.toString()) +
                              double.parse(montantverseController.text);
                      widget.facture.resteAPayer =
                          (double.parse(widget.facture.resteAPayer.toString()) -
                              double.parse(montantverseController.text));
                      widget.facture.dateOperation =
                          dateFormat.format(DateTime.now());
                      await storage
                          .retrieveAgentConnected()
                          .then((value) => agentConnected = value);
                      await storage
                          .retrieveCollectiviteConnected()
                          .then((value) => collectiviteConnected = value);
                      widget.facture.recuPaiement =
                          '${agentConnected!.matricule!.substring(8, 12)}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${Random().nextInt(1000)}';
                      print(widget.facture.recuPaiement);
                      if (double.parse(widget.facture.resteAPayer.toString()) ==
                          0) {
                        widget.facture.etatFacture = 'MOBILE_REGLEE';
                      } else {
                        widget.facture.etatFacture = 'MOBILE_REGLEMENT_PARTIEL';
                      }
                      await dbHandler.updateFacture(widget.facture.toJson());
                      pw.Document docPage = await printerService.printFacture(
                        widget.facture,
                        agentConnected!,
                        collectiviteConnected!,
                      );

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrintingPage(
                            docPage: docPage,
                          ),
                        ),
                      );
                    },
                    child: const Text('Oui'))
              ],
            );
          });
    }
  }
}
