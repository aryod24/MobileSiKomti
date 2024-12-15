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
  final TextEditingController _quotaController = TextEditingController();
  final TextEditingController _jamKompenController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

  List<Map<String, dynamic>> jenisTugasList = [];
  List<Map<String, dynamic>> kompetensiList = [];

  String? selectedJenisTugas;
  String? selectedKompetensi;
  String? selectedStatusDibuka = 'Dibuka';
  bool isSelesai = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text =
          "${picked.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isDateField = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isDateField
          ? GestureDetector(
              onTap: () => _selectDate(controller), // Trigger date picker
              child: AbsorbPointer(
                // Prevent keyboard from appearing
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(),
                  ),
                  validator: validator,
                ),
              ),
            )
          : TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
              validator: validator,
            ),
    );
  }

  Future<void> fetchDropdownData() async {
    try {
      final response =
          await Dio().get('http://192.168.1.14:8000/api/jenis-tugas');
      final kompetensiResponse =
          await Dio().get('http://192.168.1.14:8000/api/kompetensi');

      if (response.statusCode == 200 && kompetensiResponse.statusCode == 200) {
        setState(() {
          jenisTugasList =
              List<Map<String, dynamic>>.from(response.data['data']);
          kompetensiList =
              List<Map<String, dynamic>>.from(kompetensiResponse.data['data']);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      _showError('Failed to load dropdown data');
    }
  }

  Future<void> createKompen() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final nama = prefs.getString('nama');
      final userId = prefs.getString('user_id');
      final levelId = prefs.getString('level_id');

      if (userId == null || levelId == null) {
        _showError('User ID or Level ID not found. Please log in again.');
        return;
      }

      final response = await Dio().post(
        'http://192.168.1.14:8000/api/kompen',
        data: {
          'nama_kompen': _namaKompenController.text,
          'deskripsi': _deskripsiController.text,
          'jenis_tugas': int.tryParse(selectedJenisTugas ?? ''),
          'quota': int.tryParse(_quotaController.text),
          'jam_kompen': int.tryParse(_jamKompenController.text),
          'status_dibuka': selectedStatusDibuka == 'Dibuka',
          'tanggal_mulai': _tanggalMulaiController.text,
          'tanggal_akhir': _tanggalAkhirController.text,
          'is_selesai': isSelesai,
          'id_kompetensi': int.tryParse(selectedKompetensi ?? ''),
          'nama': nama,
          'user_id': userId,
          'level_id': levelId,
        },
      );

      if (response.statusCode == 201) {
        _showSuccess('Data Kompen berhasil disimpan');
      }
    } catch (e) {
      _showError('Gagal menyimpan data kompen');
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
              Navigator.pop(context);
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              _buildTextField(
                  controller: _namaKompenController, label: 'Nama Kompen'),
              _buildTextField(
                  controller: _deskripsiController, label: 'Deskripsi'),
              _buildTextField(
                  controller: _quotaController,
                  label: 'Quota',
                  keyboardType: TextInputType.number),
              _buildTextField(
                  controller: _jamKompenController,
                  label: 'Jam Kompen',
                  keyboardType: TextInputType.number),
              _buildTextField(
                  controller: _tanggalMulaiController,
                  label: 'Tanggal Mulai',
                  isDateField: true), // Date field
              _buildTextField(
                  controller: _tanggalAkhirController,
                  label: 'Tanggal Akhir',
                  isDateField: true), // Date field
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedJenisTugas,
                decoration: InputDecoration(
                  labelText: 'Jenis Tugas',
                  border: OutlineInputBorder(),
                ),
                items: jenisTugasList.map((jenis) {
                  return DropdownMenuItem(
                    value: jenis['id'].toString(),
                    child: Text(jenis['nama']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedJenisTugas = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedKompetensi,
                decoration: InputDecoration(
                  labelText: 'Kompetensi',
                  border: OutlineInputBorder(),
                ),
                items: kompetensiList.map((kompetensi) {
                  return DropdownMenuItem(
                    value: kompetensi['id'].toString(),
                    child: Text(kompetensi['nama']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKompetensi = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatusDibuka,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Dibuka', 'Ditutup'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatusDibuka = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: isSelesai
                    ? 'Selesai'
                    : 'Belum Selesai', // Set default value
                decoration: InputDecoration(
                  labelText: 'Status Selesai',
                  border: OutlineInputBorder(),
                ),
                items: ['Selesai', 'Belum Selesai'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    isSelesai = value ==
                        'Selesai'; // Update the value based on selection
                  });
                },
              ),

              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: createKompen,
                      child: Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
