import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'pdf_generator.dart';

class CertificateScreen extends StatelessWidget {
  final Map<String, dynamic> history;

  CertificateScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
          ),
        ),
        child: Column(
          children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            color: const Color(0xFF002366), // Warna card biru
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white, // Warna ikon putih
                  ),
                  const Text(
                    'Preview Qr Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.white, // Warna teks putih
                    ),
                  ),
                ],
              ),
            ),
          ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Penyelesaian Kompensasi',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                                'Nama Kompen: ${history['kompen']['nama_kompen']}'),
                            Text(
                                'Deskripsi: ${history['kompen']['deskripsi']}'),
                            Text(
                                'Tanggal Mulai: ${history['kompen']['tanggal_mulai']}'),
                            Text(
                                'Tanggal Akhir: ${history['kompen']['tanggal_akhir']}'),
                            Text('Jam Kompen: ${history['jam_kompen']}'),
                            const SizedBox(height: 20),
                            QrImageView(
                              data:
                                  'Anda telah menyelesaikan kompen oleh ${history['kompen']['nama']} dengan UUID_Kompen: ${history['kompen']['UUID_Kompen']}',
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text('Preview PDF'),
                              onPressed: () => _showPdfPreview(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPdfPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('PDF Preview')),
          body: PdfPreview(
            build: (format) => generatePdf(context, history),
          ),
        ),
      ),
    );
  }
}
