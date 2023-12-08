import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/collectivite.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:pdf/widgets.dart' as pw;

class PrinterService {
  printFacture(Facture facture, Agent agentConnected,
      Collectivite collectiviteConnected) async {
    final docPage = pw.Document();
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('images/logo_exports-02.png'))
            .buffer
            .asUint8List());
    docPage.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Divider(),
            pw.Text('${collectiviteConnected!.nom}',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center),
            pw.Text(
                'Compte contribuable : ${collectiviteConnected!.compteContribuable}'),
            pw.Text('Reference : ${collectiviteConnected!.reference}'),
            pw.Text('Téléphone : ${collectiviteConnected!.telephone}'),
            pw.Divider(),
            pw.SizedBox(
              height: 5,
            ),
            pw.Text('${facture.dateOperation}'),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('${facture.recuPaiement}',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('${facture.montantPaye} FCFA',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('Paiement taxe par App Mobile',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(
                'Contribuable : ${facture.nomContribuable} ${facture.prenomContribuable}'),
            pw.Text('Matricule : ${facture.matriculeContribuable}'),
            pw.Text('Equipement : ${facture.matriculeEquipement}'),
            pw.Text(
                'Opérateur : ${agentConnected!.nom} ${agentConnected!.prenom}'),
            pw.SizedBox(
              height: 40,
            ),
            pw.Image(
              alignment: pw.Alignment.center,
              height: 100,
              width: 100,
              logoImage,
            ),
          ],
        ),
      ),
    );
    return docPage;
  }
}
