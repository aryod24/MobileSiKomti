import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../screen/mhs/mahasiswa_screen.dart'; // Import MahasiswaScreen
import '../screen/dosen/dosen_screen.dart'; // Import DosenScreen

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.14:8000/api/', // Ganti dengan URL API Anda
    ),
  );

  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _dio.post('/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final user = response.data['user'];
        final token = response.data['token'];
        final message = response.data['message'] ?? 'Anda telah login';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user['user_id']?.toString() ?? '');
        await prefs.setString('username', user['username'] ?? '');
        await prefs.setString('nama', user['nama'] ?? '');
        await prefs.setString('jurusan', user['jurusan'] ?? '');
        await prefs.setString('ni', user['ni'] ?? '');
        await prefs.setString('level_id', user['level_id']?.toString() ?? '');
        await prefs.setString('avatar', user['avatar'] ?? '');
        await prefs.setString('token', token ?? '');

        if (!context.mounted) return;
        _showMessage(context, message);

        // Convert level_id to int for comparison
        final levelId = int.tryParse(user['level_id']?.toString() ?? '') ?? 0;

        if (!context.mounted) return;
        if (levelId == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MahasiswaScreen()),
          );
        } else if (levelId == 3 || levelId == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DosenScreen()),
          );
        } else {
          _showError(context, 'Level tidak dikenali');
        }
      } else {
        if (!context.mounted) return;
        _showError(context, response.data['message'] ?? 'Login gagal');
      }
    } on DioException catch (e) {
      if (!context.mounted) return;
      _showError(context, e.response?.data['message'] ?? 'Terjadi kesalahan');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        if (!context.mounted) return;
        _showError(context, 'Token tidak ditemukan, silakan login lagi');
        return;
      }

      final response = await _dio.post(
        '/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      await prefs.clear();

      if (!context.mounted) return;
      if (response.statusCode == 200) {
        _showMessage(context, 'Anda telah logout');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showError(context, 'Logout gagal, coba lagi');
      }
    } on DioException catch (e) {
      if (!context.mounted) return;
      _showError(context, e.response?.data['message'] ?? 'Terjadi kesalahan');
    }
  }

  // Menampilkan pesan kesalahan
  void _showError(BuildContext context, String message) {
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

  // Menampilkan pesan umum
  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Informasi'),
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
}
