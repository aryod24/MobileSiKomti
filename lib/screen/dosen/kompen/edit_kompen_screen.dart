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
              TextFormField(
                controller: _namaKompenController,
                decoration: InputDecoration(labelText: 'Nama Kompen'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama Kompen tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _jenisTugasController,
                decoration: InputDecoration(labelText: 'Jenis Tugas'),
              ),
              TextFormField(
                controller: _quotaController,
                decoration: InputDecoration(labelText: 'Quota'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _jamKompenController,
                decoration: InputDecoration(labelText: 'Jam Kompen'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _statusDibukaController,
                decoration:
                    InputDecoration(labelText: 'Status Dibuka (1=Ya, 0=Tidak)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _tanggalMulaiController,
                decoration: InputDecoration(labelText: 'Tanggal Mulai'),
              ),
              TextFormField(
                controller: _tanggalAkhirController,
                decoration: InputDecoration(labelText: 'Tanggal Akhir'),
              ),
              TextFormField(
                controller: _periodeKompenController,
                decoration: InputDecoration(labelText: 'Periode Kompen'),
              ),
              TextFormField(
                controller: _idKompetensiController,
                decoration: InputDecoration(labelText: 'ID Kompetensi'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateKompen,
                child: Text('Perbarui Kompen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
