import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/apply_kompen_services.dart';

class PengajuanScreen extends StatelessWidget {
  final String uuidKompen;

  const PengajuanScreen({super.key, required this.uuidKompen});

  @override
  Widget build(BuildContext context) {
    final ApplyKompenServices apiService = ApplyKompenServices();

    Future<void> _showConfirmationDialog(
        BuildContext context, String message, Function onConfirm) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(message)],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Ya'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await onConfirm();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showResultDialog(BuildContext context, String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hasil'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(message)],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:[Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)], // Gradient colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card with Back Button
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFF002366), // Mengatur warna card menjadi biru
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context); // Tombol back
                      },
                      color: Colors.white, // Mengubah warna ikon menjadi putih
                    ),
                    const Text(
                      'Detail Pengajuan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.white, // Mengubah warna teks menjadi putih
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
              SizedBox(height: 10), // Space between card and data table
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: apiService.fetchRequestKompen(uuidKompen),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('An error occurred'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!['data'] == null) {
                      return Center(child: Text('No data available'));
                    } else {
                      var data = snapshot.data!['data'];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double columnWidth = constraints.maxWidth /
                              5; // Dynamically adjust column width
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              border: TableBorder.all(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              columnWidths: {
                                0: FixedColumnWidth(columnWidth),
                                1: FixedColumnWidth(columnWidth),
                                2: FixedColumnWidth(columnWidth),
                                3: FixedColumnWidth(columnWidth),
                                4: FixedColumnWidth(columnWidth),
                              },
                              children: [
                                // Header with rounded corners
                                TableRow(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF00509E),
                                        Color(0xFF002366),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  children: [
                                    tableCell('ID', isHeader: true),
                                    tableCell('NI', isHeader: true),
                                    tableCell('Nama', isHeader: true),
                                    tableCell('Status', isHeader: true),
                                    tableCell('Aksi', isHeader: true),
                                  ],
                                ),
                                // Data Rows without border radius
                                ...data.map<TableRow>((item) {
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE7E9FC),
                                    ),
                                    children: [
                                      tableCell(item['id_MahasiswaKompen']
                                              ?.toString() ??
                                          '-'),
                                      tableCell(item['ni']?.toString() ?? '-'),
                                      tableCell(
                                          item['nama'] ?? 'Tidak Tersedia'),
                                      tableCell(item['status_Acc'] == 0
                                          ? 'Ditolak'
                                          : item['status_Acc'] == 1
                                              ? 'Diterima'
                                              : 'Belum Dikonfirmasi'),
                                      // Aksi Column
                                      tableCell(
                                        Center(
                                          child: PopupMenuButton<String>(
                                            icon: Icon(Icons.more_vert,
                                                size: 20), // Atur ukuran ikon
                                            onSelected: (value) async {
                                              switch (value) {
                                                case 'Approve':
                                                  await _showConfirmationDialog(
                                                    context,
                                                    'Apakah anda yakin menyetujui request nim ${item['ni']}?',
                                                    () async {
                                                      try {
                                                        await apiService
                                                            .updateStatus(
                                                          ni: item['ni']!
                                                              .toString(),
                                                          UUIDKompen:
                                                              uuidKompen,
                                                          statusAcc: 1,
                                                        );
                                                        await _showResultDialog(
                                                            context,
                                                            'Data berhasil diupdate');
                                                      } catch (e) {
                                                        await _showResultDialog(
                                                            context,
                                                            'Quota Penuh');
                                                      }
                                                    },
                                                  );
                                                  break;
                                                case 'Reject':
                                                  await _showConfirmationDialog(
                                                    context,
                                                    'Apakah anda yakin menolak request nim ${item['ni']}?',
                                                    () async {
                                                      try {
                                                        await apiService
                                                            .updateStatus(
                                                          ni: item['ni']!
                                                              .toString(),
                                                          UUIDKompen:
                                                              uuidKompen,
                                                          statusAcc: 0,
                                                        );
                                                        await _showResultDialog(
                                                            context,
                                                            'Data berhasil diupdate');
                                                      } catch (e) {
                                                        await _showResultDialog(
                                                            context,
                                                            'Data gagal diupdate');
                                                      }
                                                    },
                                                  );
                                                  break;
                                                case 'Delete':
                                                  await _showConfirmationDialog(
                                                    context,
                                                    'Apakah anda yakin menghapus request nim ${item['ni']}?',
                                                    () async {
                                                      try {
                                                        await apiService
                                                            .deleteRequest(
                                                          ni: item['ni']!
                                                              .toString(),
                                                          UUIDKompen:
                                                              uuidKompen,
                                                        );
                                                        await _showResultDialog(
                                                            context,
                                                            'Request berhasil dihapus');
                                                      } catch (e) {
                                                        await _showResultDialog(
                                                            context,
                                                            'Request gagal dihapus');
                                                      }
                                                    },
                                                  );
                                                  break;
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              PopupMenuItem<String>(
                                                value: 'Approve',
                                                child: Text('Setujui'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'Reject',
                                                child: Text('Tolak'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'Delete',
                                                child: Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tableCell(dynamic content, {bool isHeader = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content is String
            ? Text(
                content,
                textAlign: TextAlign.center, // Center align text
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: isHeader ? 13 : 12,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.bold,
                  color: isHeader ? Colors.white : Colors.black,
                ),
              )
            : content, // Handle non-string content (e.g., Row widget)
      ),
    );
  }
}
