import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/ProgressApiService.dart';
import 'package:sikomti_mobile/screen/mhs/progress/detailbukti.dart';

class CheckProgressScreen extends StatefulWidget {
  final String uuidKompen;

  const CheckProgressScreen({required this.uuidKompen, Key? key})
      : super(key: key);

  @override
  _CheckProgressScreenState createState() => _CheckProgressScreenState();
}

class _CheckProgressScreenState extends State<CheckProgressScreen> {
  late Future<List<dynamic>> progressList;
  final ProgressApiService apiService = ProgressApiService();

  @override
  void initState() {
    super.initState();
    progressList = apiService.getProgress(widget.uuidKompen);
  }

  Future<void> _deleteProgress(int idProgres) async {
    try {
      await apiService.deleteProgress(idProgres);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress berhasil dihapus')),
      );
      setState(() {
        progressList = apiService.getProgress(widget.uuidKompen);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus progress: $e')),
      );
    }
  }

  Future<void> _updateProgressStatus(int idProgres, int statusAcc) async {
    try {
      await apiService.updateBukti(idProgres, statusAcc);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            statusAcc == 1 ? 'Progress disetujui' : 'Progress ditolak',
          ),
        ),
      );
      setState(() {
        progressList = apiService.getProgress(widget.uuidKompen);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate status: $e')),
      );
    }
  }

  Future<void> _completeKompen() async {
    try {
      await apiService.selesaikanKompen(widget.uuidKompen);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kompen berhasil diselesaikan')),
      );
      setState(() {
        progressList = apiService.getProgress(widget.uuidKompen);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyelesaikan kompen: $e')),
      );
    }
  }

  void _showCompleteDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menyelesaikan Kompen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Iya'),
              onPressed: () {
                Navigator.of(context).pop();
                _completeKompen();
              },
            ),
          ],
        );
      },
    );
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
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context); // Tombol back
                      },
                      color: Colors.black,
                    ),
                    const Text(
                      'Detail Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: progressList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada progress.'));
                  } else {
                    List<dynamic> progressData = snapshot.data!;
                    return ListView.builder(
                      itemCount: progressData.length,
                      itemBuilder: (context, index) {
                        var progress = progressData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 113, 120, 158),
                                    Color.fromARGB(255, 65, 84, 129),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
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
                                          'ID: ${progress['id_progres']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Status: ${progress['status_acc'] == 1 ? 'Diterima' : 'Ditolak'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == 'accept') {
                                        _updateProgressStatus(
                                            progress['id_progres'], 1);
                                      } else if (value == 'reject') {
                                        _updateProgressStatus(
                                            progress['id_progres'], 0);
                                      } else if (value == 'delete') {
                                        _deleteProgress(progress['id_progres']);
                                      } else if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailBuktiScreen(
                                                    progress: progress),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'detail',
                                        child: Text('Detail'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'accept',
                                        child: Text('Setujui'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'reject',
                                        child: Text('Tolak'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: _showCompleteDialog,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: const Color.fromARGB(255, 65, 84, 129),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Center(
                      child: Text(
                        'Selesaikan Kompen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
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
