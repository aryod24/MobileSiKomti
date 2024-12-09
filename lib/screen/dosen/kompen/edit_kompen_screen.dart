import 'package:flutter/material.dart';
import '../../../services/KompenApiService.dart';

class EditKompenScreen extends StatefulWidget {
  final String uuidKompen;

  EditKompenScreen({required this.uuidKompen});

  @override
  _EditKompenScreenState createState() => _EditKompenScreenState();
}

class _EditKompenScreenState extends State<EditKompenScreen> {
  final KompenApiService apiService = KompenApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaKompenController;
  late TextEditingController _deskripsiController;
  late TextEditingController _jenisTugasController;
  late TextEditingController _quotaController;
  late TextEditingController _jamKompenController;
  late TextEditingController _statusDibukaController;
  late TextEditingController _tanggalMulaiController;
  late TextEditingController _tanggalAkhirController;
  late TextEditingController _periodeKompenController;
  late TextEditingController _idKompetensiController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    _namaKompenController = TextEditingController();
    _deskripsiController = TextEditingController();
    _jenisTugasController = TextEditingController();
    _quotaController = TextEditingController();
    _jamKompenController = TextEditingController();
    _statusDibukaController = TextEditingController();
    _tanggalMulaiController = TextEditingController();
    _tanggalAkhirController = TextEditingController();
    _periodeKompenController = TextEditingController();
    _idKompetensiController = TextEditingController();

    // Memuat data
    _loadKompenData();
  }

  Future<void> _loadKompenData() async {
    try {
      final data = await apiService.getKompenDetail(widget.uuidKompen);
      setState(() {
        _namaKompenController.text = data['nama_kompen'] ?? '';
        _deskripsiController.text = data['deskripsi'] ?? '';
        _jenisTugasController.text = data['jenis_tugas']?.toString() ?? '';
        _quotaController.text = data['quota']?.toString() ?? '';
        _jamKompenController.text = data['jam_kompen']?.toString() ?? '';
        _statusDibukaController.text = (data['status_dibuka'] == 1) ? '1' : '0';
        _tanggalMulaiController.text = data['tanggal_mulai'] ?? '';
        _tanggalAkhirController.text = data['tanggal_akhir'] ?? '';
        _periodeKompenController.text = data['periode_kompen'] ?? '';
        _idKompetensiController.text = data['id_kompetensi']?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> _updateKompen() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'nama_kompen': _namaKompenController.text,
        'deskripsi': _deskripsiController.text,
        'jenis_tugas': _jenisTugasController.text,
        'quota': int.tryParse(_quotaController.text) ?? 0,
        'jam_kompen': int.tryParse(_jamKompenController.text) ?? 0,
        'status_dibuka': _statusDibukaController.text == '1',
        'tanggal_mulai': _tanggalMulaiController.text,
        'tanggal_akhir': _tanggalAkhirController.text,
        'periode_kompen': _periodeKompenController.text,
        'id_kompetensi': _idKompetensiController.text,
      };

      bool success =
          await apiService.updateKompen(widget.uuidKompen, updatedData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data kompen berhasil diperbarui')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data kompen')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaKompenController.dispose();
    _deskripsiController.dispose();
    _jenisTugasController.dispose();
    _quotaController.dispose();
    _jamKompenController.dispose();
    _statusDibukaController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalAkhirController.dispose();
    _periodeKompenController.dispose();
    _idKompetensiController.dispose();
    super.dispose();
  }

  // Fungsi untuk membangun TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(), // Border yang sederhana
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kompen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _namaKompenController,
                label: 'Nama Kompen',
                validator: (value) =>
                    value!.isEmpty ? 'Nama Kompen tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _deskripsiController,
                label: 'Deskripsi',
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _jenisTugasController,
                label: 'Jenis Tugas',
              ),
              _buildTextField(
                controller: _quotaController,
                label: 'Quota',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _jamKompenController,
                label: 'Jam Kompen',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _statusDibukaController,
                label: 'Status Dibuka (1=Ya, 0=Tidak)',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _tanggalMulaiController,
                label: 'Tanggal Mulai',
              ),
              _buildTextField(
                controller: _tanggalAkhirController,
                label: 'Tanggal Akhir',
              ),
              _buildTextField(
                controller: _periodeKompenController,
                label: 'Periode Kompen',
              ),
              _buildTextField(
                controller: _idKompetensiController,
                label: 'ID Kompetensi',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateKompen,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
