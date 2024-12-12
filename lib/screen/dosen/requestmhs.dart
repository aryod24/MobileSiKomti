import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/KompenApiService.dart';
import '../../services/request_kompen_services.dart';
import 'progress/checkprogress.dart';
import 'progress/pengajuanscreen.dart';

class RequestMhsScreen extends StatefulWidget {
  @override
  _RequestMhsScreenState createState() => _RequestMhsScreenState();
}

class _RequestMhsScreenState extends State<RequestMhsScreen> {
  late Future<List<dynamic>> kompenList;
  final KompenApiService apiService = KompenApiService();
  final RequestKompenService apiServiceReq = RequestKompenService();

  @override
  void initState() {
    super.initState();
    kompenList = apiService.getKompenList();
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
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
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
                      'Progress Kompen',
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
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: kompenList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data Request'));
                  } else {
                    List<dynamic> kompenData = snapshot.data!;
                    return ListView.builder(
                      itemCount: kompenData.length,
                      itemBuilder: (context, index) {
                        var kompen = kompenData[index];
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
                                      Color(0xFF00509E),
                                      Color(0xFF002366),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
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
                                          kompen['nama_kompen'] ??
                                              'Nama Kompen',
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white),
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
                                                style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white70))),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.white70),
                                      SizedBox(width: 5),
                                      Text(
                                          'Tanggal Akhir : ${kompen['tanggal_akhir'] ?? '-'}',
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white70)),
                                    ]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PengajuanScreen(
                                              uuidKompen: kompen['UUID_Kompen'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.flag),
                                      label: const Text('Pengajuan'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(
                                            0xFF00509E), // White text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        textStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CheckProgressScreen(
                                              uuidKompen: kompen['UUID_Kompen'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.timeline),
                                      label: const Text('Progress'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(
                                            0xFF00509E), // White text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        textStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
