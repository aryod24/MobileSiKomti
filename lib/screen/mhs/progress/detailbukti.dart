import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class DetailBuktiScreen extends StatelessWidget {
  final dynamic progress;

  DetailBuktiScreen({required this.progress});

  Future<void> _downloadAndOpenFile(
      BuildContext context, String url, String fileName) async {
    if (kIsWeb) {
      // For web, open the URL in a new tab
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } else {
      try {
        final dir = await getTemporaryDirectory();
        final savePath = '${dir.path}/$fileName';

        // Download the file with efficient network request
        await Dio().download(url, savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        });

        // Open the file immediately after downloading
        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done) {
          throw Exception('Failed to open file');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File downloaded and opened successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileUrl =
        'http://192.168.1.14:8000/storage/bukti_kompen/${progress['bukti_kompen']}';
    final fileName = progress['bukti_kompen'] ?? 'file';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFF002366), // Warna card biru
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white, // Warna ikon putih
                    ),
                    const Text(
                      'Detail Bukti',
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
            const SizedBox(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
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
                                const Icon(Icons.description,
                                    color: Colors.white),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'UUID Kompen: ${progress['UUID_Kompen']}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  'Nama: ${progress['nama'] ?? 'Tidak ada nama'}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.task, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  'Nama Progress: ${progress['nama_progres'] ?? 'Tidak ada nama'}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  'Jam Kompen: ${progress['jam_kompen']}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.attach_file,
                                    color: Colors.white),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Bukti Kompen: ${progress['bukti_kompen'] ?? 'Tidak ada bukti'}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // Align to the left
                              children: [
                                Icon(
                                  progress['status_acc'] == 1
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: Color(0xFF00509E),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Status: ${progress['status_acc'] == 1 ? 'Diterima' : 'Ditolak'}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF00509E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        1), // Space between status and download button
                                Row(
                                  children: [
                                    Icon(
                                      Icons.download, // Download icon
                                      color: Colors.white, // White icon color
                                    ),
                                    const SizedBox(width: 5),
                                    ElevatedButton(
                                      onPressed: () => _downloadAndOpenFile(
                                          context, fileUrl, fileName),
                                      child: const Text(
                                        'Download',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color:
                                              Colors.white, // White text color
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            Size(90, 40), // Smaller button size
                                        backgroundColor: Color(
                                            0xFF00509E), // Background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
