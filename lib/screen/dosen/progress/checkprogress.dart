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
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40), // Reduced space here
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF002366),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                    ),
                    const Text(
                      'Detail Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
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
                        var currentProgress = progressData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00509E),
                                    Color(0xFF002366),
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
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'NIM: ${currentProgress['ni']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.account_circle,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Nama: ${currentProgress['nama']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Status: ${currentProgress['status_acc'] == 1 ? "Diterima" : "Ditolak"}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == 'accept') {
                                        _updateProgressStatus(
                                            currentProgress['id_progres'], 1);
                                      } else if (value == 'reject') {
                                        _updateProgressStatus(
                                            currentProgress['id_progres'], 0);
                                      } else if (value == 'delete') {
                                        _deleteProgress(
                                            currentProgress['id_progres']);
                                      } else if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailBuktiScreen(
                                              progress: currentProgress,
                                            ),
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
                  color: const Color(0xFF00509E),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
