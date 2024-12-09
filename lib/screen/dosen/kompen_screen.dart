import 'package:flutter/material.dart';
import '../../services/KompenApiService.dart';
import 'kompen/create_kompen_screen.dart'; // Import halaman CreateKompenScreen
import 'kompen/popup_menu_kompen.dart'; // Import widget PopupMenuKompen

class KompenScreen extends StatefulWidget {
  @override
  _KompenScreenState createState() => _KompenScreenState();
}

class _KompenScreenState extends State<KompenScreen> {
  late Future<List<dynamic>> kompenList;
  final KompenApiService apiService = KompenApiService();

  @override
  void initState() {
    super.initState();
    kompenList = apiService.getKompenList();
  }

  Future<void> deleteKompen(String uuid) async {
    try {
      final response = await apiService.deleteKompen(uuid);
      if (response['status'] == true) {
        setState(() {
          kompenList = apiService.getKompenList();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Kompen berhasil dihapus')));
      } else {
        throw Exception('Gagal menghapus kompen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 1),
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
                      'List Daftar Kompen',
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
            SizedBox(
                height: 10), // Space between card and next widget (adjustable)
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: kompenList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada data kompen'));
                  } else {
                    List<dynamic> kompenData = snapshot.data!;
                    return ListView.builder(
                      itemCount: kompenData.length,
                      itemBuilder: (context, index) {
                        var kompen = kompenData[index];

                        int quota = kompen['quota'] ?? 0;
                        int jamKompen = kompen['jam_kompen'] ?? 0;
                        int statusDibuka = kompen['status_dibuka'] ?? 0;

                        return Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              // Bagian dengan Linear Gradient
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF00509E),
                                      Color(0xFF002366),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nama Kompen dan Detail
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.category,
                                                      color: Colors.white),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    kompen['nama_kompen'] ??
                                                        'Kategori',
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.description,
                                                      color: Colors.white70),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      kompen['deskripsi'] ??
                                                          'Deskripsi tidak tersedia',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today,
                                                      color: Colors.white70),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    'Tanggal Akhir: ${kompen['tanggal_akhir'] ?? '-'}',
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.task,
                                                      color: Colors.white70),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    (kompen['jenis_tugas'] == 1
                                                        ? 'Penelitian'
                                                        : kompen['jenis_tugas'] ==
                                                                2
                                                            ? 'Pengabdian'
                                                            : kompen['jenis_tugas'] ==
                                                                    3
                                                                ? 'Teknis'
                                                                : 'Jenis Tugas'),
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Jam dan Quota di kanan atas
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_filled,
                                                    color: Colors.white),
                                                SizedBox(width: 5),
                                                Text(
                                                  '$jamKompen jam',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(Icons.group,
                                                    color: Colors.white),
                                                SizedBox(width: 5),
                                                Text(
                                                  '$quota Quota',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            PopupMenuKompen(
                                              uuidKompen: kompen['UUID_Kompen'],
                                              onDelete: () => deleteKompen(
                                                  kompen['UUID_Kompen']),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Bagian putih di bawah
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.toggle_on, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Text(
                                      'Status: ${statusDibuka == 0 ? "Ya" : "Tidak"}',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_kompen_fab', // Changed to a unique tag
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateKompenScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
