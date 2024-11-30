import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  final Dio _dio = Dio();
  final String baseUrl = "http://192.168.1.14:8000/api/";

  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    try {
      final response = await _dio.get(baseUrl + 'users/$userId');
      if (response.statusCode == 200) {
        return response.data; // Return the user profile data
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  // Mendapatkan data user berdasarkan ID
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    try {
      final response = await _dio.get(baseUrl + 'users/$userId');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Failed to load user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Memperbarui data user
  Future<bool> updateUser(int _userId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    String _userId = prefs.getString('user_id') ?? '';
    try {
      final response = await _dio.put(baseUrl + 'users/$_userId', data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update user data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
