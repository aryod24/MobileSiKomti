import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikomti_mobile/services/HistoryApiService.dart';

class HasilScreenDosen extends StatefulWidget {
  @override
  _HasilScreenDosenState createState() => _HasilScreenDosenState();
}

class _HasilScreenDosenState extends State<HasilScreenDosen> {
  late Future<List<dynamic>> historyList =
      Future.value([]); // Initialize with an empty Future
  final HistoryApiService apiService = HistoryApiService();

  @override
  void initState() {
    super.initState();
    _fetchHistoryDosen();
  }

  Future<void> _fetchHistoryDosen() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    if (userId.isNotEmpty) {
      historyList = apiService.historyKompenDosen(userId);
      setState(() {});
    } else {
      setState(() {
        historyList =
            Future.value([]); // If no user_id, set historyList to an empty list
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
            colors: [Color(0xFFFED7C3), Color(0xFFFEEFE5)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 1), // Jarak awal
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'History Kompen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 113, 120, 158),
                                      Color.fromARGB(255, 65, 84, 129),
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
                                        Icon(Icons.category,
                                            color: Colors.white),
                                        SizedBox(width: 5),
                                        Text(
                                          history['nama_kompen'] ??
                                              'Nama Kompen',
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
                                            history['deskripsi'] ??
                                                'Deskripsi tidak tersedia',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
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
                                          'Tanggal Akhir: ${history['tanggal_akhir'] ?? '-'}',
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
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.grey),
                                    SizedBox(width: 5),
                                    Text(
                                      'Status: ${history['Is_Selesai'] == 1 ? "Selesai" : "Belum Selesai"}',
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
    );
  }
}
