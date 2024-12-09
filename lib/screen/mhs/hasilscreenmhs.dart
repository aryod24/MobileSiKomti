import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikomti_mobile/services/HistoryApiService.dart';
import 'history/qrexport.dart';

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
        historyList =
            Future.value([]); // If no ni, set historyList to an empty list
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
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0xFF002366), // Warna card biru
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'History Kompen',
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
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
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
                                      children: [
                                        const Icon(Icons.category,
                                            color: Colors.white),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            'Nama Kompen: ${history['kompen']['nama_kompen']}',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.description,
                                            color: Colors.white70),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            'Deskripsi: ${history['kompen']['deskripsi']}',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            color: Colors.white70),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Tanggal: ${history['kompen']['tanggal_mulai']} - ${history['kompen']['tanggal_akhir']}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            color: Colors.white70),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Jam Kompen: ${history['jam_kompen']}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          history['kompen']['Is_Selesai'] == 1
                                              ? Icons.check_circle_outline
                                              : Icons.cancel,
                                          color:
                                              Color(0xFF00509E),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          'Status: ${history['kompen']['Is_Selesai'] == 1 ? 'Selesai' : 'Belum Selesai'}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF00509E),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CertificateScreen(
                                                    history: history),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFF00509E),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cetak',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
    );
  }
}
