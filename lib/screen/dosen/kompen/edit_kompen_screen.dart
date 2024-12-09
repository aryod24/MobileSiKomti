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
  bool _isLoading = false;

  late TextEditingController _namaKompenController;
  late TextEditingController _deskripsiController;
  late TextEditingController _quotaController;
  late TextEditingController _jamKompenController;
  late TextEditingController _tanggalMulaiController;
  late TextEditingController _tanggalAkhirController;
  late TextEditingController _periodeKompenController;

  List<Map<String, dynamic>> jenisTugasList = [];
  List<Map<String, dynamic>> kompetensiList = [];

  String? selectedJenisTugas;
  String? selectedKompetensi;
  String? selectedStatusDibuka = 'Dibuka';
  bool isSelesai = false;

  @override
  void initState() {
    super.initState();
    _namaKompenController = TextEditingController();
    _deskripsiController = TextEditingController();
    _quotaController = TextEditingController();
    _jamKompenController = TextEditingController();
    _tanggalMulaiController = TextEditingController();
    _tanggalAkhirController = TextEditingController();
    _periodeKompenController = TextEditingController();

    // Load dropdown data first
    _loadDropdownData().then((_) {
      // Then load kompen data
      _loadKompenData();
    });
  }

  Future<void> _loadDropdownData() async {
    try {
      final response = await apiService.getJenisTugas();
      final kompetensiResponse = await apiService.getKompetensi();

      setState(() {
        jenisTugasList =
            List<Map<String, dynamic>>.from(response['data'] ?? []);
        kompetensiList =
            List<Map<String, dynamic>>.from(kompetensiResponse['data'] ?? []);
      });
    } catch (e) {
      _showError('Gagal memuat data dropdown: $e');
    }
  }

  Future<void> _loadKompenData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await apiService.getKompenDetail(widget.uuidKompen);

      setState(() {
        _namaKompenController.text = data['nama_kompen'] ?? '';
        _deskripsiController.text = data['deskripsi'] ?? '';
        _quotaController.text = data['quota']?.toString() ?? '';
        _jamKompenController.text = data['jam_kompen']?.toString() ?? '';
        selectedStatusDibuka =
            (data['status_dibuka'] == 1) ? 'Dibuka' : 'Ditutup';
        _tanggalMulaiController.text = data['tanggal_mulai'] ?? '';
        _tanggalAkhirController.text = data['tanggal_akhir'] ?? '';
        _periodeKompenController.text = data['periode_kompen'] ?? '';

        // Find matching jenis tugas from list
        if (data['jenis_tugas'] != null) {
          final jenisTugas = jenisTugasList.firstWhere(
            (element) => element['id'] == data['jenis_tugas'],
            orElse: () => {'id': null},
          );
          selectedJenisTugas = jenisTugas['id']?.toString();
        }

        if (data['id_kompetensi'] != null) {
          final kompetensi = kompetensiList.firstWhere(
            (element) => element['id'] == data['id_kompetensi'],
            orElse: () => {'id': null},
          );
          selectedKompetensi = kompetensi['id']?.toString();
        }

        isSelesai = data['is_selesai'] == 1;
      });
    } catch (e) {
      _showError('Gagal memuat data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateKompen() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Map<String, dynamic> updatedData = {
          'nama_kompen': _namaKompenController.text,
          'deskripsi': _deskripsiController.text,
          'jenis_tugas': int.tryParse(selectedJenisTugas ?? ''),
          'quota': int.tryParse(_quotaController.text) ?? 0,
          'jam_kompen': int.tryParse(_jamKompenController.text) ?? 0,
          'status_dibuka': selectedStatusDibuka == 'Dibuka',
          'tanggal_mulai': _tanggalMulaiController.text,
          'tanggal_akhir': _tanggalAkhirController.text,
          'periode_kompen': _periodeKompenController.text,
          'id_kompetensi': int.tryParse(selectedKompetensi ?? ''),
          'is_selesai': isSelesai,
        };

        bool success =
            await apiService.updateKompen(widget.uuidKompen, updatedData);

        if (success) {
          _showSuccess('Data kompen berhasil diperbarui');
        } else {
          _showError('Gagal memperbarui data kompen');
        }
      } catch (e) {
        _showError('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context);
  }

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
          border: OutlineInputBorder(),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      controller: _namaKompenController,
                      label: 'Nama Kompen',
                      validator: (value) => value!.isEmpty
                          ? 'Nama Kompen tidak boleh kosong'
                          : null,
                    ),
                    _buildTextField(
                      controller: _deskripsiController,
                      label: 'Deskripsi',
                    ),
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
                    _buildTextField(
                      controller: _tanggalMulaiController,
                      label: 'Tanggal Mulai (YYYY-MM-DD)',
                    ),
                    _buildTextField(
                      controller: _tanggalAkhirController,
                      label: 'Tanggal Akhir (YYYY-MM-DD)',
                    ),
                    _buildTextField(
                      controller: _periodeKompenController,
                      label: 'Periode Kompen',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Is Selesai'),
                        Switch(
                          value: isSelesai,
                          onChanged: (value) {
                            setState(() {
                              isSelesai = value;
                            });
                          },
                        ),
                      ],
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
