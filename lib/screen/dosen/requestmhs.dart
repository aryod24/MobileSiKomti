import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/KompenApiService.dart';
import '../../services/request_kompen_services.dart';
import 'checkprogress.dart';
import 'pengajuanscreen.dart'; // Import the PengajuanScreen

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

  Future<void> checkProgress(String uuid) async {
    try {
      final response = await apiServiceReq.checkProgress(uuid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Progres berhasil diperiksa'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
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
            const SizedBox(height: 1),
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
                      'Request Kompen',
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
                    return const Center(child: Text('Tidak ada data kompen'));
                  } else {
                    List<dynamic> kompenData = snapshot.data!;
                    return ListView.builder(
                      itemCount: kompenData.length,
                      itemBuilder: (context, index) {
                        var kompen = kompenData[index];
                        int quota = kompen['quota'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 113, 120, 158),
                                  Color.fromARGB(255, 65, 84, 129),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kompen['nama_kompen'] ?? 'Nama Kompen',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '$quota Quota',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'pengajuan') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PengajuanScreen(
                                            uuidKompen: kompen['UUID_Kompen'],
                                          ),
                                        ),
                                      );
                                    } else if (value == 'progress') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CheckProgressScreen(
                                            uuidKompen: kompen['UUID_Kompen'],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'pengajuan',
                                      child: Text('Pengajuan'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'progress',
                                      child: Text('Progress'),
                                    ),
                                  ],
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
