import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/register_service.dart';
import 'login_screen.dart'; // Ensure this import is present

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _niController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  List<Map<String, dynamic>> levelList = [];
  String? selectedLevelId; // This can be nullable
  bool _isLoading = false;
  final RegisterService _registerService = RegisterService();

  @override
  void initState() {
    super.initState();
    fetchLevelData();
  }

  Future<void> fetchLevelData() async {
    try {
      final response = await Dio().get('http://192.168.1.14:8000/api/levels');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          levelList =
              data.where((level) => level['level_id'] != 1).map((level) {
            return {
              'id': level['level_id']?.toString() ??
                  '', // Convert to string and handle null
              'kode': level['level_kode'] ?? '', // Handle null
              'nama': level['level_nama'] ?? '', // Handle null
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching level data: $e');
    }
  }

  void _register() async {
    if (selectedLevelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a level')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _registerService.register(
        username: _usernameController.text,
        nama: _namaController.text,
        jurusan: _jurusanController.text,
        ni: _niController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        levelId: selectedLevelId!, // Ensure non-null value here
        context: context,
      );

      if (response['success']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Registration successful!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/logonew.png',
                          width: 140,
                          height: 140,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        DropdownButtonFormField<String>(
                          value: selectedLevelId,
                          decoration: InputDecoration(
                            labelText: 'Level',
                            labelStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items:
                              levelList.map<DropdownMenuItem<String>>((level) {
                            return DropdownMenuItem<String>(
                              value: level['id'],
                              child:
                                  Text('${level['kode']} - ${level['nama']}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevelId = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Other form fields
                        _buildTextField(_usernameController, 'Username'),
                        const SizedBox(height: 20),
                        _buildTextField(_namaController, 'Nama'),
                        const SizedBox(height: 20),
                        _buildTextField(_jurusanController, 'Jurusan'),
                        const SizedBox(height: 20),
                        _buildTextField(_niController, 'Nomor Induk'),
                        const SizedBox(height: 20),
                        _buildTextField(_passwordController, 'Password',
                            obscureText: true),
                        const SizedBox(height: 20),
                        _buildTextField(
                            _passwordConfirmationController, 'Confirm Password',
                            obscureText: true),
                        const SizedBox(height: 30),

                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _buildRegisterButton(context),
                        const SizedBox(height: 20),
                        _buildLoginPrompt(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xFF002366), borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: !_isLoading ? _register : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Daftar',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: const Text(
        'Sudah punya akun? Login',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
