import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

Future<Uint8List> generatePdf(
    BuildContext context, Map<String, dynamic> history) async {
  final pdf = pw.Document();

  final ByteData bytes = await rootBundle.load('assets/image/polinema-bw.png');
  final Uint8List imgBytes = bytes.buffer.asUint8List();

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header (Kop Surat)
            pw.Row(
              children: [
                pw.Container(
                  width: 80,
                  height: 80,
                  child: pw.Image(pw.MemoryImage(imgBytes)),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET DAN TEKNOLOGI',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        'POLITEKNIK NEGERI MALANG',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        'PROGRAM STUDI TEKNIK INFORMATIKA',
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        'Jl. Soekarno Hatta No.9 Malang 65141',
                        style: const pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        'Telp. 0341404424 Fax. 0341404420, http://www.poltek-malang.ac.id',
                        style: const pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),

            // Title
            pw.Center(
              child: pw.Text(
                'BERITA ACARA KOMPENSASI PRESENSI',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            // Content
            pw.Text('Nama Pengajar    : ${history['kompen']['nama'] ?? ''}'),
            pw.Text(
                'NIP             : ${history['kompen']['user_details']['ni'] ?? ''}'),
            pw.SizedBox(height: 10),
            pw.Text('Memberikan rekomendasi kompensasi kepada:'),
            pw.SizedBox(height: 5),
            _buildRow('Nama Mahasiswa', history['nama']),
            _buildRow('NIM', history['ni']),
            _buildRow('Kelas', history['kelas']),
            _buildRow('Semester', history['semester']),
            _buildRow('Pekerjaan', history['kompen']['nama_kompen']),
            _buildRow('Jumlah Jam', '${history['jam_kompen']} jam'),
            pw.SizedBox(height: 20),

            // QR Code and Signature
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Mengetahui,'),
                    pw.Text('Ka. Program Studi'),
                    pw.SizedBox(height: 60),
                    pw.Text('(Hendra Pradibta, SE., M.Sc.)'),
                    pw.Text('NIP. 198305212006041003'),
                  ],
                ),
                pw.Center(
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data:
                        'Anda telah menyelesaikan Kompen dengan UUID_Kompen: ${history['kompen']['UUID_Kompen']}',
                    width: 100,
                    height: 100,
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Malang, ........................'),
                    pw.Text('Yang memberikan rekomendasi,'),
                    pw.SizedBox(height: 60),
                    pw.Text('(....................................)'),
                    pw.Text('NIP.'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('FRM.RIF.01.07.03'),
            pw.Text(
                'NB: Form ini wajib disimpan untuk keperluan bebas tanggungan'),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildRow(String label, String? value) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        width: 120,
        child: pw.Text(label),
      ),
      pw.Container(
        width: 20,
        child: pw.Text(':'),
      ),
      pw.Expanded(
        child: pw.Text(value ?? ''),
      ),
    ],
  );
}
