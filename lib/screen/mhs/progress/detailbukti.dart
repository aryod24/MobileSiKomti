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
      appBar: AppBar(
        title: const Text('Detail Bukti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UUID Kompen: ${progress['UUID_Kompen']}'),
            const SizedBox(height: 5),
            Text('Nama: ${progress['nama'] ?? 'Tidak ada nama'}'),
            const SizedBox(height: 5),
            Text('Jam Kompen: ${progress['jam_kompen']}'),
            const SizedBox(height: 5),
            Text(
                'Status: ${progress['status_acc'] == 1 ? 'Diterima' : 'Ditolak'}'),
            const SizedBox(height: 5),
            Text(
                'Bukti Kompen: ${progress['bukti_kompen'] ?? 'Tidak ada bukti'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _downloadAndOpenFile(context, fileUrl, fileName),
              child: const Text('Download Bukti'),
            ),
          ],
        ),
      ),
    );
  }
}
