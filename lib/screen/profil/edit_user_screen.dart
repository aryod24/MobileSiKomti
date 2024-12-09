import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_api_services.dart'; // Import UserApiService

class EditUserScreen extends StatefulWidget {
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserApiService apiService = UserApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _namaController;
  late TextEditingController _jurusanController;
  late TextEditingController _niController;
  late TextEditingController _levelIdController;
  late int _userId; // Change this to int

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _usernameController = TextEditingController();
    _namaController = TextEditingController();
    _jurusanController = TextEditingController();
    _niController = TextEditingController();
    _levelIdController = TextEditingController();

    // Load user data
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdStr = prefs.getString('user_id') ?? ''; // Get as String

      // Parse it as an integer
      _userId = int.tryParse(userIdStr) ?? 0; // Ensure it's an integer

      final data = await apiService.getUserById(_userId);
      setState(() {
        _usernameController.text = data!['username'] ?? '';
        _namaController.text = data['nama'] ?? '';
        _jurusanController.text = data['jurusan'] ?? '';
        _niController.text = data['ni'] ?? '';
        _levelIdController.text = data['level_id']?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'username': _usernameController.text,
        'nama': _namaController.text,
        'jurusan': _jurusanController.text,
        'ni': _niController.text,
        // Include level_id only if it's not empty
        if (_levelIdController.text.isNotEmpty)
          'level_id': int.tryParse(_levelIdController.text) ?? null,
      };

      bool success = await apiService.updateUser(
          _userId, updatedData); // Pass _userId (as int)

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data user berhasil diperbarui')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data user')),
        );
      }
    }
  }

  // Function to handle Cancel button press
  void _cancelEdit() {
    // You can either navigate back or reset the form fields
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _namaController.dispose();
    _jurusanController.dispose();
    _niController.dispose();
    _levelIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false, // Remove back button if not needed
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:Color(0xFF00509E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Username tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _jurusanController,
                        decoration: InputDecoration(
                          labelText: 'Jurusan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _niController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Induk (NI)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _levelIdController,
                        decoration: InputDecoration(
                          labelText: 'Level ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      // Row with both buttons next to each other
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Update button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _updateUser,
                              child: const Text(
                                'Perbarui Data',
                                style: TextStyle(color: Colors.white), // Mengubah warna teks menjadi putih
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Color(0xFF00509E),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Add space between the buttons
                          // Cancel button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _cancelEdit,
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.white), // Mengubah warna teks menjadi putih
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
