import 'package:flutter/material.dart';
import '../../services/auth_services.dart'; // Import AuthService
import 'register_screen.dart'; // Import RegisterScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final AuthService _authService = AuthService(); // Instance of AuthService

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        username: _usernameController.text,
        password: _passwordController.text,
        context: context,
      );
    } catch (e) {
      // Handle any errors here, e.g., show an error message
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Ubah latar belakang menjadi putih
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // LOGO - using Image.asset directly
                Image.asset(
                  'assets/image/logonew.png', // Load image from assets
                  width: 140, // Adjust width
                  height: 140, // Adjust height
                ),
                const SizedBox(height: 40),
                const Text(
                  'Silahkan Login\nke akun Anda',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black, // Ubah teks menjadi hitam
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                // Username Field
                _buildTextField('Masukkan nama Anda', _usernameController),
                const SizedBox(height: 20),
                // Password Field
                _buildTextField('Masukkan password Anda', _passwordController,
                    obscureText: true),
                const SizedBox(height: 30),
                // Login Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildLoginButton(),
                const SizedBox(height: 20),
                // Registration Prompt
                _buildRegisterPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat TextField dengan parameter hint text dan controller
  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Fungsi untuk tombol login
  Widget _buildLoginButton() {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF002366), // Warna tombol biru
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white, // Teks tetap putih
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menambahkan prompt pendaftaran
  Widget _buildRegisterPrompt(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ),
        );
      },
      child: const Text(
        'Belum punya akun? Daftar',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.black, // Ubah teks menjadi hitam
        ),
      ),
    );
  }
}
