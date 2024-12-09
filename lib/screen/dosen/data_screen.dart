import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/data_service.dart';
import 'alpha/edit_mahasiswaalpha.dart';
import 'alpha/createalphascreen.dart';
import '/models/mahasiswa_alpha.dart';
import 'alpha/export_data_screen.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataService _dataService = DataService();

  late Future<List<MahasiswaAlpha>> _mahasiswaAlphaList;

  @override
  void initState() {
    super.initState();
    _mahasiswaAlphaList = _dataService.fetchMahasiswaAlpha();
  }

  // Modify tableCell method to allow wrapping of text for header
  Widget tableCell(String text, {bool isHeader = false, double height = 50}) {
    return Container(
      height: height, // Atur tinggi sel
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.bold,
          color: isHeader ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
          fontSize: isHeader ? 10 : 9,
          fontFamily: 'Montserrat',
        ),
        textAlign: TextAlign.center,
        softWrap: isHeader, // Allow text to wrap for headers
        overflow: isHeader
            ? TextOverflow.visible
            : TextOverflow.ellipsis, // Prevent overflow in header
      ),
    );
  }

  // In your TableRow for the header
  TableRow mahasiswaRow(BuildContext context, MahasiswaAlpha mahasiswa) {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFFE7E9FC),
      ),
      children: [
        tableCell(mahasiswa.ni, height: 40),
        tableCell(mahasiswa.nama ?? 'Tidak Ada', height: 40),
        tableCell(mahasiswa.semester, height: 40),
        tableCell(mahasiswa.jamAlpha.toString(), height: 40),
        tableCell(mahasiswa.jamKompen?.toString() ?? 'N/A', height: 40),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          height: 40,
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 18),
            onSelected: (value) {
              switch (value) {
                case 'Detail':
                  _showDetails(mahasiswa);
                  break;
                case 'Edit':
                  _editMahasiswaAlpha(mahasiswa);
                  break;
                case 'Delete':
                  _deleteMahasiswaAlpha(mahasiswa.idAlpha);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Detail',
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: const Color.fromARGB(255, 6, 104, 185), size: 20), // Icon for Detail
                    SizedBox(width: 10),
                    Text('Detail'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange, size: 20), // Icon for Edit
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20), // Icon for Delete
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDetails(MahasiswaAlpha item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF00509E), // Warna latar belakang biru
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Detail Mahasiswa Alpha',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(Icons.person, 'NIM', item.ni),
              _detailRow(Icons.account_circle, 'Nama', item.nama ?? 'Tidak Ada'),
              _detailRow(Icons.school, 'Semester', item.semester.toString()),
              _detailRow(Icons.alarm, 'Jam Alpha', item.jamAlpha.toString()),
              _detailRow(
                Icons.check_circle,
                'Jam Kompen',
                item.jamKompen?.toString() ?? 'N/A',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _editMahasiswaAlpha(MahasiswaAlpha item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMahasiswaAlphaScreen(mahasiswaAlpha: item),
      ),
    );

    if (result == true) {
      setState(() {
        _mahasiswaAlphaList = _dataService.fetchMahasiswaAlpha();
      });
    }
  }

  void _deleteMahasiswaAlpha(int idAlpha) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan'),
          content: Text('Apakah Anda yakin untuk menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _dataService.deleteMahasiswaAlpha(idAlpha);
                  Navigator.of(context).pop(); // Close dialog
                  setState(() {
                    _mahasiswaAlphaList = _dataService.fetchMahasiswaAlpha();
                  });
                } catch (e) {
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete item')),
                  );
                }
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _createMahasiswaAlpha() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAlphaScreen(),
      ),
    );

    if (result == true) {
      setState(() {
        _mahasiswaAlphaList = _dataService.fetchMahasiswaAlpha();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 1),
            Center(
              child: Container(
                width: 400,
                child: Card(
                  elevation: 4,
                  color: Color(0xFF002366), // Warna biru header
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Data Mahasiswa Alpha',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Teks putih
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Jarak setelah judul
            Expanded(
              child: FutureBuilder<List<MahasiswaAlpha>>(
                future: _mahasiswaAlphaList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('An error occurred'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Radius untuk tabel
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(75),
                            1: FixedColumnWidth(100),
                            2: FixedColumnWidth(50),
                            3: FixedColumnWidth(50),
                            4: FixedColumnWidth(63),
                            5: FixedColumnWidth(40),
                          },
                          border: TableBorder.all(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00509E),
                                    Color(0xFF002366),
                                  ],
                                ),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              children: [
                                tableCell('NIM', isHeader: true, height: 50),
                                tableCell('Nama', isHeader: true, height: 50),
                                tableCell('Semester',
                                    isHeader: true, height: 50),
                                tableCell('Jam Alpha',
                                    isHeader: true, height: 50),
                                tableCell('Jam Kompen',
                                    isHeader: true, height: 50),
                                tableCell('Aksi', isHeader: true, height: 50),
                              ],
                            ),
                            for (var mahasiswa in data)
                              mahasiswaRow(context, mahasiswa),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _createMahasiswaAlpha,
            child: const Icon(Icons.add),
            tooltip: 'Add Mahasiswa Alpha',
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExportDataScreen(
                    mahasiswaAlphaList: _mahasiswaAlphaList,
                  ),
                ),
              );
            },
            child: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export Data',
          ),
        ],
      ),
    );
  }
}
