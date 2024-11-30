import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikomti_mobile/services/HistoryApiService.dart';
import 'qrexport.dart';

class HasilScreenMahasiswa extends StatefulWidget {
  @override
  _HasilScreenMahasiswaState createState() => _HasilScreenMahasiswaState();
}

class _HasilScreenMahasiswaState extends State<HasilScreenMahasiswa> {
  late Future<List<dynamic>> historyList =
      Future.value([]); // Initialize with an empty Future
  final HistoryApiService apiService = HistoryApiService();

  @override
  void initState() {
    super.initState();
    _fetchHistoryMhs();
  }

  Future<void> _fetchHistoryMhs() async {
    final prefs = await SharedPreferences.getInstance();
    final ni = prefs.getString('ni') ?? '';
    if (ni.isNotEmpty) {
      setState(() {
        historyList = apiService.historyKompenMhs(ni);
      });
    } else {
      setState(() {
        historyList = Future.value([]); // If no ni, set historyList to an empty list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFED7C3), Color(0xFFFEEFE5)],
          ),
        ),
        child: Column(
          children: [
            // White Card with 'History Kompen' text
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: const Text(
                  'History Kompen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            // FutureBuilder for fetching history data
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: historyList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada riwayat kompen.'));
                  } else {
                    List<dynamic> historyData = snapshot.data!;
                    return ListView.builder(
                      itemCount: historyData.length,
                      itemBuilder: (context, index) {
                        var history = historyData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Kompen: ${history['kompen']['nama_kompen']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Deskripsi: ${history['kompen']['deskripsi']}'),
                                const SizedBox(height: 5),
                                Text('Tanggal Mulai: ${history['kompen']['tanggal_mulai']}'),
                                const SizedBox(height: 5),
                                Text('Tanggal Akhir: ${history['kompen']['tanggal_akhir']}'),
                                const SizedBox(height: 5),
                                Text('Jam Kompen: ${history['jam_kompen']}'),
                                const SizedBox(height: 5),
                                Text('Status: ${history['kompen']['Is_Selesai'] == 1 ? 'Selesai' : 'Belum Selesai'}'),
                                const SizedBox(height: 5),
                                ElevatedButton(
                                  child: const Text('Cetak'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CertificateScreen(history: history),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
    );
  }
}
