import 'package:flutter/material.dart';
import '../../../services/KompenApiService.dart';

class KompenDetailScreen extends StatefulWidget {
  final String uuidKompen;

  KompenDetailScreen({required this.uuidKompen});

  @override
  _KompenDetailScreenState createState() => _KompenDetailScreenState();
}

class _KompenDetailScreenState extends State<KompenDetailScreen> {
  late Future<Map<String, dynamic>> kompenDetail;
  final KompenApiService apiService = KompenApiService();

  @override
  void initState() {
    super.initState();
    kompenDetail = apiService.getKompenDetail(widget.uuidKompen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: kompenDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data kompen tidak ditemukan'));
          } else {
            var kompen = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 250, 250, 250),
                      Color.fromARGB(255, 255, 255, 255)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    buildHeaderCard(context),
                    const SizedBox(height: 20),
                    buildDetailCard(context, kompen),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Method to build the header card
  Widget buildHeaderCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      color: const Color(0xFF002366), // Mengatur warna card menjadi biru
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white, // Mengubah warna ikon menjadi putih
            ),
            const SizedBox(width: 8),
            const Text(
              'Detail Kompen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.white, // Mengubah warna teks menjadi putih
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the detail card with all details
  Widget buildDetailCard(BuildContext context, Map<String, dynamic> kompen) {
    final List<Map<String, dynamic>> details = [
      {
        'icon': Icons.info,
        'title': 'UUID Kompen',
        'subtitle': widget.uuidKompen
      },
      {'icon': Icons.person, 'title': 'User ID', 'subtitle': kompen['user_id']},
      {
        'icon': Icons.accessibility,
        'title': 'Level ID',
        'subtitle': _getUserRole(kompen['level_id'])
      },
      {
        'icon': Icons.description,
        'title': 'Nama Kompen',
        'subtitle': kompen['nama_kompen']
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Deskripsi',
        'subtitle': kompen['deskripsi']
      },
      {
        'icon': Icons.work,
        'title': 'Jenis Tugas',
        'subtitle': _getJenisTugas(kompen['jenis_tugas'])
      },
      {'icon': Icons.schedule, 'title': 'Quota', 'subtitle': kompen['quota']},
      {
        'icon': Icons.timer,
        'title': 'Jam Kompen',
        'subtitle': kompen['jam_kompen']
      },
      {
        'icon': Icons.visibility,
        'title': 'Status Dibuka',
        'subtitle': _getStatusDibuka(kompen['status_dibuka'])
      },
      {
        'icon': Icons.calendar_today,
        'title': 'Tanggal Mulai',
        'subtitle': kompen['tanggal_mulai']
      },
      {
        'icon': Icons.calendar_today_outlined,
        'title': 'Tanggal Akhir',
        'subtitle': kompen['tanggal_akhir']
      },
      {
        'icon': Icons.check,
        'title': 'Is Selesai',
        'subtitle': kompen['is_selesai']
      },
      {
        'icon': Icons.assignment,
        'title': 'ID Kompetensi',
        'subtitle': _getIdKompetensi(kompen['id_kompetensi'])
      },
      {
        'icon': Icons.date_range,
        'title': 'Periode Kompen',
        'subtitle': kompen['periode_kompen']
      },
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00509E),
            Color(0xFF002366),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details.map((detail) {
            return ListTile(
              leading: Icon(detail['icon'], color: Colors.white),
              title: Text(
                detail['title'],
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                detail['subtitle'].toString(),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getUserRole(dynamic levelId) {
    if (levelId == 1) {
      return 'Admin';
    } else if (levelId == 3) {
      return 'Dosen';
    } else if (levelId == 4) {
      return 'Tendik';
    } else {
      return 'null'; // Default for other user_ids
    }
  }

  // Get Jenis Tugas description based on jenis_tugas code
  String _getJenisTugas(dynamic jenisTugas) {
    switch (jenisTugas) {
      case 1:
        return 'Penelitian';
      case 2:
        return 'Pengabdian';
      case 3:
        return 'Teknis';
      default:
        return 'Tidak tersedia';
    }
  }

  // Get Status Dibuka description based on status_dibuka code
  String _getStatusDibuka(dynamic statusDibuka) {
    return (statusDibuka == 1)
        ? 'Dibuka'
        : (statusDibuka == 2)
            ? 'Ditutup'
            : 'Tidak tersedia';
  }

  // Get ID Kompetensi description based on id_kompetensi code
  String _getIdKompetensi(dynamic idKompetensi) {
    switch (idKompetensi) {
      case 1:
        return 'Analisis Data';
      case 2:
        return 'Keterampilan Komunikasi';
      case 3:
        return 'Digital Marketing';
      case 4:
        return 'UI/UX Design';
      case 5:
        return 'Sistem Operasi';
      case 6:
        return 'Analisis dan Desain Sistem';
      case 7:
        return 'Jaringan Komputer';
      case 8:
        return 'Pengolahan Data';
      case 9:
        return 'Pengembangan Web';
      case 10:
        return 'Manajemen Database';
      default:
        return 'Tidak tersedia';
    }
  }
}
