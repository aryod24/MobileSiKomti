import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateKompenScreen extends StatefulWidget {
  @override
  _CreateKompenScreenState createState() => _CreateKompenScreenState();
}

class _CreateKompenScreenState extends State<CreateKompenScreen> {
  final TextEditingController _namaKompenController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _selectedJenisTugas; // Dropdown for Jenis Tugas
  String? _selectedStatusDibuka = 'Dibuka'; // Dropdown for Status Dibuka
  final TextEditingController _quotaController = TextEditingController();
  final TextEditingController _jamKompenController = TextEditingController();
  final TextEditingController _periodeKompenController =
      TextEditingController();
  final TextEditingController _tanggalMulaiController =
      TextEditingController(); // New field
  final TextEditingController _tanggalAkhirController =
      TextEditingController(); // New field
  bool _isSelesai = false; // Boolean for Is Selesai
  String? _selectedIdKompetensi; // Dropdown for ID Kompetensi

  bool _isLoading = false;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.6:8000/api/', // Replace with your API URL
    ),
  );

  Future<void> createKompen() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user_id and level_id from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final nama = prefs.getString('nama');
      final userId = prefs.getString('user_id');
      final levelId = prefs.getString('level_id');

      if (userId == null || levelId == null) {
        _showError('User ID or Level ID not found. Please log in again.');
        return;
      }

      // Prepare data for API request
      final response = await _dio.post('/kompen', data: {
        'nama_kompen': _namaKompenController.text,
        'deskripsi': _deskripsiController.text,
        'jenis_tugas': int.tryParse(_selectedJenisTugas ?? ''),
        'quota': int.tryParse(_quotaController.text),
        'jam_kompen': int.tryParse(_jamKompenController.text),
        'periode_kompen': _periodeKompenController.text,
        'status_dibuka': _selectedStatusDibuka == 'Dibuka',
        'tanggal_mulai': _tanggalMulaiController.text,
        'tanggal_akhir': _tanggalAkhirController.text,
        'is_selesai': _isSelesai,
        'id_kompetensi': int.tryParse(_selectedIdKompetensi ?? ''),
        'nama': nama,
        'user_id': userId,
        'level_id': levelId,
      });

      if (response.statusCode == 201) {
        _showSuccess('Data Kompen successfully created!');
      } else {
        _showError(response.data['message'] ?? 'Failed to create Kompen data.');
      }
    } on DioError catch (e) {
      _showError(e.response?.data['message'] ?? 'An error occurred.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the previous page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Kompen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input fields
            TextField(
              controller: _namaKompenController,
              decoration: InputDecoration(labelText: 'Nama Kompen'),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedJenisTugas,
              decoration: InputDecoration(labelText: 'Jenis Tugas'),
              items: [
                DropdownMenuItem(value: '1', child: Text('Penelitian')),
                DropdownMenuItem(value: '2', child: Text('Pengabdian')),
                DropdownMenuItem(value: '3', child: Text('Teknis')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedJenisTugas = value;
                });
              },
            ),
            TextField(
              controller: _quotaController,
              decoration: InputDecoration(labelText: 'Quota'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _jamKompenController,
              decoration: InputDecoration(labelText: 'Jam Kompen'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _periodeKompenController,
              decoration: InputDecoration(labelText: 'Periode Kompen'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedStatusDibuka,
              decoration: InputDecoration(labelText: 'Status Dibuka'),
              items: [
                DropdownMenuItem(value: 'Dibuka', child: Text('Dibuka')),
                DropdownMenuItem(value: 'Ditutup', child: Text('Ditutup')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatusDibuka = value;
                });
              },
            ),
            TextField(
              controller: _tanggalMulaiController,
              decoration:
                  InputDecoration(labelText: 'Tanggal Mulai (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _tanggalAkhirController,
              decoration:
                  InputDecoration(labelText: 'Tanggal Akhir (YYYY-MM-DD)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Is Selesai'),
                Switch(
                  value: _isSelesai,
                  onChanged: (value) {
                    setState(() {
                      _isSelesai = value;
                    });
                  },
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _selectedIdKompetensi,
              decoration: InputDecoration(labelText: 'ID Kompetensi'),
              items: [
                DropdownMenuItem(value: '1', child: Text('Analisis Data')),
                DropdownMenuItem(
                    value: '2', child: Text('Keterampilan Komunikasi')),
                DropdownMenuItem(value: '3', child: Text('Digital Marketing')),
                DropdownMenuItem(value: '4', child: Text('UI/UX Design')),
                DropdownMenuItem(value: '5', child: Text('Sistem Operasi')),
                DropdownMenuItem(
                    value: '6', child: Text('Analisis dan Desain Sistem')),
                DropdownMenuItem(value: '7', child: Text('Jaringan Komputer')),
                DropdownMenuItem(value: '8', child: Text('Pengolahan Data')),
                DropdownMenuItem(value: '9', child: Text('Pengembangan Web')),
                DropdownMenuItem(
                    value: '10', child: Text('Manajemen Database')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIdKompetensi = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Loading indicator or button
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: createKompen,
                child: Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}
