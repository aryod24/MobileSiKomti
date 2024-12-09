import 'package:flutter/material.dart';
import 'package:sikomti_mobile/models/mahasiswa_alpha.dart';
import 'package:sikomti_mobile/services/data_service.dart';

class EditMahasiswaAlphaScreen extends StatefulWidget {
  final MahasiswaAlpha mahasiswaAlpha;

  EditMahasiswaAlphaScreen({required this.mahasiswaAlpha});

  @override
  _EditMahasiswaAlphaScreenState createState() =>
      _EditMahasiswaAlphaScreenState();
}

class _EditMahasiswaAlphaScreenState extends State<EditMahasiswaAlphaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _niController;
  late TextEditingController _namaController;
  late TextEditingController _jamAlphaController;
  late TextEditingController _semesterController;
  late TextEditingController _jamKompenController;

  @override
  void initState() {
    super.initState();
    _niController = TextEditingController(text: widget.mahasiswaAlpha.ni);
    _namaController = TextEditingController(text: widget.mahasiswaAlpha.nama);
    _jamAlphaController =
        TextEditingController(text: widget.mahasiswaAlpha.jamAlpha.toString());
    _semesterController =
        TextEditingController(text: widget.mahasiswaAlpha.semester);
    _jamKompenController = TextEditingController(
        text: widget.mahasiswaAlpha.jamKompen?.toString() ?? '');
  }

  @override
  void dispose() {
    _niController.dispose();
    _namaController.dispose();
    _jamAlphaController.dispose();
    _semesterController.dispose();
    _jamKompenController.dispose();
    super.dispose();
  }

  // Function to build text fields consistently
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
          border: OutlineInputBorder(), // Simple border
        ),
        validator: validator,
      ),
    );
  }

  void _updateMahasiswaAlpha() async {
    if (_formKey.currentState!.validate()) {
      final updatedMahasiswaAlpha = MahasiswaAlpha(
        idAlpha: widget.mahasiswaAlpha.idAlpha,
        ni: _niController.text,
        nama: _namaController.text,
        jamAlpha: int.parse(_jamAlphaController.text),
        semester: _semesterController.text,
        jamKompen: _jamKompenController.text.isNotEmpty
            ? int.parse(_jamKompenController.text)
            : null,
      );

      try {
        final dataService = DataService();
        final response =
            await dataService.updateMahasiswaAlpha(updatedMahasiswaAlpha);

        if (response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          Navigator.of(context).pop(true); // Return true on success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update data')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mahasiswa Alpha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _niController,
                label: 'NIM',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NIM';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _namaController,
                label: 'Nama',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _jamAlphaController,
                label: 'Jam Alpha',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Jam Alpha';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _semesterController,
                label: 'Semester',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Semester';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _jamKompenController,
                label: 'Jam Kompen',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMahasiswaAlpha,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
