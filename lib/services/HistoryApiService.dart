import 'package:dio/dio.dart';

class HistoryApiService {
  final String baseUrl = 'http://192.168.1.14:8000/api';
  final Dio _dio = Dio();

  Future<List<dynamic>> historyKompenDosen(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/history-kompen-dosen/$userId');
      if (response.statusCode == 200) {
        return response.data['kompen'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> historyKompenMhs(String ni) async {
    try {
      final response = await _dio.get('$baseUrl/history-kompen-mhs/$ni');
      if (response.statusCode == 200) {
        return response.data['progress'];
      } else {
        return []; // Return an empty list if the response status code is not 200
      }
    } catch (e) {
      return []; // Return an empty list if an exception occurs
    }
  }
}
