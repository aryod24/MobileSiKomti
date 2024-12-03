import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikomti_mobile/services/ProgressApiService.dart';
import 'kompen_bukti.dart';

class ProgressKompenScreen extends StatefulWidget {
  @override
  _ProgressKompenScreenState createState() => _ProgressKompenScreenState();
}

class _ProgressKompenScreenState extends State<ProgressKompenScreen> {
  late Future<List<dynamic>> kompenRequests;
  final ProgressApiService apiService = ProgressApiService();
  bool showRequests = true;

  @override
  void initState() {
    super.initState();
    kompenRequests = Future.value([]);
    _fetchKompenData();
  }

  Future<void> _fetchKompenData() async {
    final prefs = await SharedPreferences.getInstance();
    final ni = prefs.getString('ni') ?? '';
    if (ni.isNotEmpty) {
      setState(() {
        kompenRequests = apiService.getKompenRequests(ni);
      });
    } else {
      setState(() {
        kompenRequests = Future.value([]);
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
            // Row untuk tombol Request dan Progress
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => showRequests = true),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: showRequests
                          ? const Color.fromARGB(255, 113, 120, 158)
                          : Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Request',
                          style: TextStyle(
                            color: showRequests ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => showRequests = false),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: !showRequests
                          ? const Color.fromARGB(255, 113, 120, 158)
                          : Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Progress',
                          style: TextStyle(
                            color: !showRequests ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Card "Request Kompen" hanya tampil jika showRequests true
            if (showRequests)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
            // Konten yang bergantung pada showRequests
            Expanded(
              child: showRequests
                  ? FutureBuilder<List<dynamic>>(
                      future: kompenRequests,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child:
                                  Text('Terjadi kesalahan: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada request kompen.'));
                        } else {
                          List<dynamic> requestsData = snapshot.data!;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: requestsData.length,
                            itemBuilder: (context, index) {
                              var request = requestsData[index];
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.category,
                                                            color:
                                                                Colors.white),
                                                        const SizedBox(
                                                            width: 2),
                                                        Text(
                                                          request['kompen_details']
                                                                  [
                                                                  'nama_kompen'] ??
                                                              'Tidak ada nama kompen',
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.description,
                                                            color:
                                                                Colors.white70),
                                                        const SizedBox(
                                                            width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            'UUID Kompen: ${request['UUID_Kompen']}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  color: Colors.white),
                                              const SizedBox(width: 5),
                                              Text(
                                                request['kompen_details']
                                                        ['nama'] ??
                                                    'Tidak ada nama',
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
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            request['status_Acc'] == 1
                                                ? Icons.check_circle_outline
                                                : Icons.cancel,
                                            color: Color.fromARGB(
                                                255, 65, 84, 129),
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            'Status: ${request['status_Acc'] == 1 ? 'Diterima' : 'Ditolak'}',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Color.fromARGB(
                                                  255, 65, 84, 129),
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
                    )
                  : KompenBukti(),
            ),
          ],
        ),
      ),
    );
  }
}
