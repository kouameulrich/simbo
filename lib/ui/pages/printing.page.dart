import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simbo_mobile/ui/pages/collecte.page.dart';
import 'dart:typed_data';

class PrintingPage extends StatefulWidget {
  final pw.Document docPage;
  PrintingPage({Key? key, required this.docPage}) : super(key: key);

  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  List<BluetoothDevice> device = [];
  BluetoothDevice? selectedDevices;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    device = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollectePage(),
              )),
        ),
        centerTitle: true,
        title: const Text('Preview Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              value: selectedDevices,
              hint: Text('Select printer'),
              items: device
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toString()),
                      ))
                  .toList(),
              onChanged: (device) {
                selectedDevices = device;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  printer.connect(selectedDevices!);
                },
                child: Text('Connect')),
            ElevatedButton(
                onPressed: () {
                  printer.disconnect();
                },
                child: Text('Disconnect')),
            ElevatedButton(
              onPressed: () async {
                if (selectedDevices != null) {
                  await printer.connect(selectedDevices!);

                  if ((await printer.isConnected)!) {
                    final Uint8List pdfBytes = await widget.docPage.save();
                    await printer.writeBytes(pdfBytes);
                    await printer.paperCut();
                    print('------------  DONNÉES  -----------');
                    print(pdfBytes);
                  } else {
                    print('Erreur de connexion à l\'imprimante');
                  }
                } else {
                  print('Aucune imprimante sélectionnée');
                }
              },
              child: Text('Imprimer'),
            ),
          ],
        ),
      ),
    );
  }
}
