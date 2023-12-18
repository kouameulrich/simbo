import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simbo_mobile/ui/pages/collecte.page.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintingPage extends StatefulWidget {
  final pw.Document docPage;
  PrintingPage({Key? key, required this.docPage}) : super(key: key);

  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String? _devicesMsg;

  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    bluetoothManager.state.listen((val) {
      if (!mounted) return;
      if (val == 12) {
        initPrinter();
        print('on');
      } else if (val == 10) {
        print('off');
        setState(() {
          _devicesMsg = 'Bluetooth Disconnect!';
        });
      }
    });
    print(widget.docPage);
    super.initState();
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
      body: _devices.isEmpty
          ? Center(
              child: Text(_devicesMsg ?? ''),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_devices[index].name.toString()),
                  subtitle: Text(_devices[index].address.toString()),
                  onTap: () {
                    _startPrint(_devices[index]);
                  },
                );
              },
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;

      setState(() {
        _devices = val;
      });
      print(_devices);
      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = 'No Devices';
        });
      }

      print(val);
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(_ticket(PaperSize.mm80) as List<int>);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(result.msg),
            ));
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    int total = 0;
    // ticket.text('test');
    ticket.text(
      'SIMBO',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    Uint8List result = await widget.docPage.save();
    for (var i = 0; i < result.length; i++) {
      total += result[i];
    }
    ticket.cut();
    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    // TODO: implement dispose
    super.dispose();
  }
}

class Ticket {
  // Vos méthodes et propriétés ici
  Ticket(PaperSize paper) {
    // Initialisation de la classe Ticket
  }

  void text(String text, {required PosStyles styles}) {
    // Implémentation de la méthode text
  }

  void cut() {
    // Implémentation de la méthode cut
  }
}
