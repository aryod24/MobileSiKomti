import 'dart:convert';
import 'package:dio/dio.dart';

class ApplyKompenServices {
  final Dio _dio = Dio();

  // Define the base URL for your API
  final String baseUrl =
      'http://192.168.1.14:8000/api'; // Replace with your actual API URL

  // Method to update the status of a Kompen request (Accept/Reject)
  Future<Map<String, dynamic>> updateStatus({
    required String ni,
    required String UUIDKompen,
    required int statusAcc,
  }) async {
    final url = '$baseUrl/update-status';

    // Prepare the request body
    final body = {
      'ni': ni,
      'UUID_Kompen': UUIDKompen,
      'status_Acc': statusAcc,
    };

    try {
      final response = await _dio.put(
        url,
        data: json.encode(body),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return successful response data
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to delete a Kompen request
  Future<Map<String, dynamic>> deleteRequest({
    required String ni,
    required String UUIDKompen,
  }) async {
    final url = '$baseUrl/delete-request';

    // Prepare the request body
    final body = {
      'ni': ni,
      'UUID_Kompen': UUIDKompen,
    };

    try {
      final response = await _dio.delete(
        url,
        data: json.encode(body),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return successful response data
      } else {
        throw Exception('Failed to delete request');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchRequestKompen(String uuid) async {
    try {
      final response = await _dio.get("${baseUrl}/kompen/request/$uuid");
      if (response.statusCode == 200) {
        // Jika berhasil, kembalikan data dari API
        return {
          'status': true,
          'message': 'Data berhasil diambil.',
          'data': response.data['data'],
        };
      } else if (response.statusCode == 404) {
        // Jika tidak ditemukan, kembalikan status false dengan pesan
        return {
          'status': false,
          'message': response.data['message'] ??
              "No kompen request found for this UUID_Kompen.",
        };
      } else {
        // Jika status code lainnya
        return {
          'status': false,
          'message':
              "Gagal mengambil data kompen. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      // Tangani error lainnya tanpa exception
      return {
        'status': false,
        'message': "Belum ada Request.",
      };
    }
  }
}
