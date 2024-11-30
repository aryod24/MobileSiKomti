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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                              color:
                                  !showRequests ? Colors.white : Colors.black,
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
              if (showRequests) ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
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
                FutureBuilder<List<dynamic>>(
                  future: kompenRequests,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Terjadi kesalahan: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada request kompen.'));
                    } else {
                      List<dynamic> requestsData = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: requestsData.length,
                        itemBuilder: (context, index) {
                          var request = requestsData[index];
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
                                  Text(
                                    'UUID Kompen: ${request['UUID_Kompen']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                      'Nama Kompen: ${request['kompen_details']['nama_kompen'] ?? 'Tidak ada nama kompen'}'),
                                  const SizedBox(height: 5),
                                  Text(
                                      'Nama: ${request['kompen_details']['nama'] ?? 'Tidak ada nama'}'),
                                  const SizedBox(height: 5),
                                  Text(
                                      'Status: ${request['status_Acc'] == 1 ? 'Diterima' : 'Ditolak'}'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ] else
                KompenBukti(),
            ],
          ),
        ),
      ),
    );
  }
}
