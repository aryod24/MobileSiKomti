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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 125, 167, 223),
              Color.fromARGB(255, 235, 218, 191),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // LOGO - using Image.asset directly
                    Image.asset(
                      'assets/image/LOGO.png', // Load image from assets
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
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 50),
                    // Username Field
                    _buildTextField('Masukkan nama Anda', _usernameController),
                    const SizedBox(height: 20),
                    // Password Field
                    _buildTextField(
                        'Masukkan password Anda', _passwordController,
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
            _buildBackButton(context),
          ],
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
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 113, 120, 158),
            Color.fromARGB(255, 65, 84, 129),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        ),
        child: const Text(
          'Login',
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

  // Fungsi untuk tombol kembali
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black54,
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
              builder: (context) =>
                  RegisterScreen()), // Ganti dengan halaman pendaftaran mahasiswa
        );
      },
      child: const Text('Belum punya akun? Daftar',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    );
  }
}
