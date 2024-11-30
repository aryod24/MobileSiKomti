import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> register({
    required String username,
    required String nama,
    required String jurusan,
    required String ni,
    required String password,
    required String passwordConfirmation,
    required String levelId,
    required BuildContext context,
  }) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.14:8000/api/register',
        data: {
          'username': username,
          'nama': nama,
          'jurusan': jurusan,
          'ni': ni,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'level_id': levelId,
        },
      );

      if (response.statusCode == 201) {
        // Assuming the API returns a JSON object with a success flag and a message
        return {
          'success': response.data['success'] ?? false,
          'message': response.data['message'] ?? 'Registration failed.',
        };
      } else {
        return {
          'success': false,
          'message':
              'Unexpected error occurred. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message':
            'An error occurred while trying to register. Please try again.',
      };
    }
  }
}
