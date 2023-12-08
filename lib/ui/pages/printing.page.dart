import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simbo_mobile/ui/pages/collecte.page.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart' as pdf;

class PrintingPage extends StatefulWidget {
  pw.Document docPage;
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
                  if ((await printer.isConnected)!) {
                    printer.printNewLine();
                    // SIZE
                    // 0: normal
                    // 1: normal-bold
                    // 2: medium-bold
                    // 3: large-biold

                    // ALIGN
                    // 0: left
                    // 1: center
                    // 2: rigth
                    printer.printCustom('${widget.docPage.toString()}', 0, 1);
                    printer.printQRcode('textToQR', 200, 200, 1);

                    print("-----------   DATA ---------");
                    print(widget.docPage);
                  }
                },
                child: Text('Print'))
          ],
        ),
      ),
    );
  }
}
