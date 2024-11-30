import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikomti_mobile/screen/mhs/UploadBuktiScreen.dart';
import 'package:sikomti_mobile/screen/mhs/detailbukti.dart';
import 'package:sikomti_mobile/services/ProgressApiService.dart';

class KompenBukti extends StatefulWidget {
  @override
  _KompenBuktiState createState() => _KompenBuktiState();
}

class _KompenBuktiState extends State<KompenBukti> {
  late Future<List<dynamic>> kompenProgress;
  final ProgressApiService apiService = ProgressApiService();

  @override
  void initState() {
    super.initState();
    kompenProgress = Future.value([]); // Initialize with an empty list
    _fetchKompenProgressData();
  }

  Future<void> _fetchKompenProgressData() async {
    final prefs = await SharedPreferences.getInstance();
    final ni = prefs.getString('ni') ?? '';
    if (ni.isNotEmpty) {
      setState(() {
        kompenProgress = apiService.getKompenProgress(ni);
      });
    } else {
      setState(() {
        kompenProgress = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Progress Kompen',
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
        FutureBuilder<List<dynamic>>(
          future: kompenProgress,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada progress kompen.'));
            } else {
              List<dynamic> progressData = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: progressData.length,
                itemBuilder: (context, index) {
                  var progress = progressData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nama: ${progress['kompen']['nama_kompen'] ?? 'Tidak ada nama'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Detail') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailBuktiScreen(
                                            progress: progress),
                                      ),
                                    );
                                  } else if (value == 'Upload Bukti') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadBuktiScreen(
                                            progress: progress),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return {'Detail', 'Upload Bukti'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text('Jam Kompen: ${progress['jam_kompen']}'),
                          const SizedBox(height: 5),
                          Text(
                              'Status: ${progress['status_acc'] == 1 ? 'Diterima' : 'Ditolak'}'),
                          const SizedBox(height: 5),
                          Text(
                              'Bukti Kompen: ${progress['bukti_kompen'] ?? 'Tidak ada bukti'}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
