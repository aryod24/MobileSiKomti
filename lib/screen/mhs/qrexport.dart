import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateScreen extends StatelessWidget {
  final Map<String, dynamic> history;

  CertificateScreen({required this.history});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sertifikat Kompen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sertifikat Penyelesaian Kompen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Nama Kompen: ${history['kompen']['nama_kompen']}'),
            Text('Deskripsi: ${history['kompen']['deskripsi']}'),
            Text('Tanggal Mulai: ${history['kompen']['tanggal_mulai']}'),
            Text('Tanggal Akhir: ${history['kompen']['tanggal_akhir']}'),
            Text('Jam Kompen: ${history['jam_kompen']}'),
            SizedBox(height: 20),
            QrImageView(
              data:
                  'Anda telah menyelesaikan kompen oleh Dosen dengan UUID_Kompen: ${history['kompen']['UUID_Kompen']}',
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Cetak PDF'),
              onPressed: () => _generatePdf(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Surat Penyelesaian Kompen',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Nama Kompen: ${history['kompen']['nama_kompen']}'),
                pw.Text('Deskripsi: ${history['kompen']['deskripsi']}'),
                pw.Text('Tanggal Mulai: ${history['kompen']['tanggal_mulai']}'),
                pw.Text('Tanggal Akhir: ${history['kompen']['tanggal_akhir']}'),
                pw.Text('Jam Kompen: ${history['jam_kompen']}'),
                pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data:
                      'Anda telah menyelesaikan kompen oleh Dosen dengan UUID_Kompen: ${history['kompen']['UUID_Kompen']}',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
