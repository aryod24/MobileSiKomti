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
        throw Exception('Gagal mengambil data history kompen dosen');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data history kompen dosen: $e');
    }
  }

  Future<List<dynamic>> historyKompenMhs(String ni) async {
    try {
      final response = await _dio.get('$baseUrl/history-kompen-mhs/$ni');
      if (response.statusCode == 200) {
        return response.data['progress'];
      } else {
        throw Exception('Gagal mengambil data history kompen mahasiswa');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data history kompen mahasiswa: $e');
    }
  }
}
