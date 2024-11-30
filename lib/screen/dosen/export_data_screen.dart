import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:sikomti_mobile/models/mahasiswa_alpha.dart';
import 'package:printing/printing.dart';
import 'export.pdf.dart';

class ExportDataScreen extends StatelessWidget {
  final Future<List<MahasiswaAlpha>> mahasiswaAlphaList;

  ExportDataScreen({required this.mahasiswaAlphaList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _exportToPDF(context),
              child: Text('Export to PDF'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<MahasiswaAlpha>>(
                future: mahasiswaAlphaList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  } else {
                    final pdfData = snapshot.data!
                        .map((mahasiswa) => {
                              'ni': mahasiswa.ni,
                              'nama': mahasiswa.nama,
                              'semester': mahasiswa.semester,
                              'jam_alpha': mahasiswa.jamAlpha,
                              'jam_kompen': mahasiswa.jamKompen,
                            })
                        .toList();

                    return PdfPreview(
                      build: (format) => generatePDF(pdfData, context),
                      initialPageFormat: PdfPageFormat.a4,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportToPDF(BuildContext context) async {
    try {
      final data = await mahasiswaAlphaList;
      final pdfData = data
          .map((mahasiswa) => {
                'ni': mahasiswa.ni,
                'nama': mahasiswa.nama,
                'semester': mahasiswa.semester,
                'jam_alpha': mahasiswa.jamAlpha,
                'jam_kompen': mahasiswa.jamKompen,
              })
          .toList();

      // Call the exportToPDF function with context
      await exportToPDF(pdfData, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF berhasil dibuat dan disimpan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat PDF: $e')),
      );
    }
  }
}
