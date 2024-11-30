import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UploadBuktiScreen extends StatefulWidget {
  final dynamic progress;

  UploadBuktiScreen({required this.progress});

  @override
  _UploadBuktiScreenState createState() => _UploadBuktiScreenState();
}

class _UploadBuktiScreenState extends State<UploadBuktiScreen> {
  FilePickerResult? _selectedFile;
  final TextEditingController _namaProgresController = TextEditingController();
  final Dio _dio = Dio();

  Future<void> _uploadBukti() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file to upload')),
      );
      return;
    }

    try {
      PlatformFile file = _selectedFile!.files.first;

      FormData formData;
      if (kIsWeb) {
        formData = FormData.fromMap({
          'id_progres': widget.progress['id_progres'],
          'nama_progres': _namaProgresController.text,
          'bukti_kompen':
              MultipartFile.fromBytes(file.bytes!, filename: file.name),
        });
      } else {
        formData = FormData.fromMap({
          'id_progres': widget.progress['id_progres'],
          'nama_progres': _namaProgresController.text,
          'bukti_kompen':
              await MultipartFile.fromFile(file.path!, filename: file.name),
        });
      }

      Response response = await _dio.post(
        'http://192.168.1.14:8000/api/upload-bukti',
        data: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti kompen uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload bukti kompen')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'zip'],
    );

    setState(() {
      _selectedFile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Bukti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Upload Bukti Screen for UUID Kompen: ${widget.progress['UUID_Kompen']}'),
            const SizedBox(height: 20),
            TextField(
              controller: _namaProgresController,
              decoration: InputDecoration(
                labelText: 'Nama Progres',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Select File'),
            ),
            const SizedBox(height: 20),
            _selectedFile != null
                ? Text('Selected File: ${_selectedFile!.files.first.name}')
                : Text('No file selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadBukti,
              child: Text('Upload Bukti'),
            ),
          ],
        ),
      ),
    );
  }
}
