import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/facture.dart';

class PrintingPage extends StatefulWidget {
  Facture facture;
  Collectivite collectiviteConnected;
  Agent agentConnected;
  PrintingPage(
      {Key? key,
      required this.facture,
      required this.collectiviteConnected,
      required this.agentConnected})
      : super(key: key);

  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMPRESSION"),
        backgroundColor: const Color(0xff2f7b5f),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              hint: Text('Selectionner une imprimante'),
              items: devices
                  .map((e) => DropdownMenuItem(
                        child: Text(e.name!),
                        value: e,
                      ))
                  .toList(),
              onChanged: (device) {
                setState(() {
                  selectedDevice = device;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  printer.connect(selectedDevice!);
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff2f7b5f),
                ),
                child: const Text('Connecter')),
            ElevatedButton(
                onPressed: () {
                  printer.disconnect();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff2f7b5f),
                ),
                child: const Text('Déconnecter')),
            ElevatedButton(
                onPressed: () async {
                  if ((await printer.isConnected)!) {
                    printer.printNewLine();
                    //SIZE
                    // 0: Normal
                    // 1: Normal - Bold
                    // 2: Medium - Bold
                    // 4: Large - Bold

                    //ALIGN
                    // 0: left
                    // 1: center
                    // 2: right
                    printer.printCustom('SIMBO', 4, 1);
                    printer.printNewLine();
                    printer.printCustom(
                        widget.collectiviteConnected!.nom.toString(), 0, 1);
                    printer.printNewLine();
                    printer.printCustom(
                        'CTB:' + widget.collectiviteConnected!.code.toString(),
                        0,
                        1);
                    printer.printCustom(
                        'REF:' +
                            widget.collectiviteConnected!.reference.toString(),
                        0,
                        1);
                    printer.printCustom(
                        'TEL:' +
                            widget.collectiviteConnected!.telephone.toString(),
                        0,
                        1);
                    printer.printCustom(
                        'FAX:' +
                            widget.collectiviteConnected!.adresse.toString(),
                        0,
                        1);
                    printer.printNewLine();
                    printer.printNewLine();
                    printer.printNewLine();
                    printer.printCustom('Paiement Taxe anterieure', 1, 1);
                    printer.printCustom(
                        widget.facture!.recuPaiement.toString(), 1, 1);
                    printer.printCustom(
                        widget.facture!.dateOperation.toString(), 1, 1);
                    printer.printNewLine();
                    printer.printNewLine();
                    printer.printCustom(
                        widget.facture!.montantPaye.toString(), 1, 1);
                    printer.printNewLine();
                    printer.printNewLine();
                    printer.print4Column(
                        'Contribuable:' +
                            widget.facture!.nomContribuable.toString(),
                        'Matricule' +
                            widget.facture!.matriculeContribuable.toString(),
                        'Equipement' +
                            widget.facture!.matriculeEquipement.toString(),
                        'Agent:' + widget.agentConnected!.nom.toString(),
                        1);
                    printer.printQRcode('Thermal Print Demo', 200, 200, 1);
                    printer.printNewLine();
                    printer.printCustom('Powered by ORBIT', 1, 1);
                    printer.printNewLine();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff2f7b5f),
                ),
                child: const Text('Imprimer')),
          ],
        ),
      ),
    );
  }
}
