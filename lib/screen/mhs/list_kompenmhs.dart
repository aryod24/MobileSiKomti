import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/KompenApiService.dart'; // Import your API service for fetching kompen list
import '../../services/request_kompen_services.dart'; // Import the request service
import '../dosen/kompen/kompen_detail_screen.dart'; // Import detail screen

class ListKompenScreen extends StatefulWidget {
  @override
  _ListKompenScreenState createState() => _ListKompenScreenState();
}

class _ListKompenScreenState extends State<ListKompenScreen> {
  late Future<List<dynamic>> kompenList;
  final KompenApiService apiService = KompenApiService();
  final RequestKompenService requestService = RequestKompenService();

  @override
  void initState() {
    super.initState();
    kompenList = apiService.getKompenListAll();
  }

  Future<void> _requestKompen(String uuidKompen) async {
    final prefs = await SharedPreferences.getInstance();
    String? ni = prefs.getString('ni');
    String? nama = prefs.getString('nama');

    if (ni != null) {
      try {
        // Memeriksa apakah permohonan sudah ada
        final checkResponse =
            await requestService.checkExistingRequest(uuidKompen, ni);

        if (checkResponse) {
          // Jika permohonan sudah ada, tampilkan notifikasi dan keluar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Anda sudah mengajukan permohonan untuk kompen ini.'),
            ),
          );
          return; // Keluar jika sudah dimohon
        }

        // Mengirim permohonan kompen jika belum ada
        final response =
            await requestService.requestKompen(uuidKompen, ni, nama!);

        if (response) {
          // Tampilkan dialog sukses jika permohonan berhasil
          _showSuccessDialog();
        } else {
          // Tampilkan notifikasi gagal jika permohonan gagal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anda Berhasil Request'),
            ),
          );
        }
      } on DioError catch (e) {
        // Tangani kesalahan dari Dio dengan pesan spesifik
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan jaringan: ${e.message}')),
        );
      } catch (e) {
        // Tangani kesalahan lainnya dengan pesan spesifik
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda Berhasil Request')),
        );
      }
    } else {
      // Tampilkan notifikasi jika NI tidak ditemukan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NI tidak ditemukan.')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Permohonan kompen berhasil!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRequestDialog(String uuidKompen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content:
              const Text('Anda yakin ingin mengajukan permohonan kompen ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _requestKompen(
                    uuidKompen); // Panggil fungsi untuk mengajukan permohonan
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  String getJenisTugas(int jenisTugas) {
    switch (jenisTugas) {
      case 1:
        return 'Penelitian';
      case 2:
        return 'Pengabdian';
      case 3:
        return 'Teknis';
      default:
        return 'Tidak Diketahui';
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              color: const Color(0xFF002366), // Warna card biru
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'List Kompen',
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
                        String jenisTugas =
                            getJenisTugas(kompen['jenis_tugas']);
                        int quota = kompen['quota'] ?? 0;
                        int jamKompen = kompen['jam_kompen'] ?? 0;
                        int statusDibuka = kompen['status_dibuka'] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            // Prevent requesting if status_dibuka is 0
                            if (statusDibuka == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Kompen ini sudah tidak dibuka untuk request'),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KompenDetailScreen(
                                    uuidKompen: kompen['UUID_Kompen'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Stack(
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
                                                          kompen['nama_kompen'] ??
                                                              'Kategori',
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
                                                            kompen['deskripsi'] ??
                                                                'Deskripsi tidak tersedia',
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
                                              const Icon(Icons.work_outline,
                                                  color: Colors.white),
                                              const SizedBox(width: 5),
                                              Text(
                                                '$jenisTugas',
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
                                    Positioned(
                                      right: 10,
                                      top: 16,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.group,
                                                  color: Colors.white),
                                              const SizedBox(width: 2),
                                              Text(
                                                '$quota',
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time,
                                                  color: Colors.white),
                                              const SizedBox(width: 2),
                                              Text(
                                                '$jamKompen jam',
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
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.toggle_on,
                                              color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            'Status: ${statusDibuka == 0 ? "Ditutup" : "Dibuka"}',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: statusDibuka == 0
                                            ? null // Disable button if status is 0
                                            : () => _showRequestDialog(
                                                kompen['UUID_Kompen']),
                                        icon: const Icon(Icons.flag,
                                            color: Color.fromARGB(188, 0, 79, 158)),
                                      ),
                                    ],
                                  ),
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
