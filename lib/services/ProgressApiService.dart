import 'package:dio/dio.dart';

class ProgressApiService {
  final String baseUrl = 'http://192.168.1.14:8000/api';
  final Dio _dio = Dio();

  Future<List<dynamic>> getProgress(String uuidKompen) async {
    try {
      final response = await _dio.get('$baseUrl/view-bukti/$uuidKompen');
      if (response.statusCode == 200) {
        return response.data['bukti'];
      } else {
        throw Exception('Gagal mengambil data progress');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data progress: $e');
    }
  }

  Future<void> deleteProgress(int idProgres) async {
    try {
      final response = await _dio.post(
        '$baseUrl/delete-request',
        data: {'id_progres': idProgres.toString()},
      );
      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus progress');
      }
    } catch (e) {
      throw Exception('Gagal menghapus progress: $e');
    }
  }

  Future<void> updateBukti(int idProgres, int statusAcc) async {
    try {
      final response = await _dio.put(
        '$baseUrl/update-bukti',
        data: {
          'id_progres': idProgres.toString(),
          'status_acc': statusAcc.toString()
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Gagal mengupdate status');
      }
    } catch (e) {
      throw Exception('Gagal mengupdate status: $e');
    }
  }

  Future<void> selesaikanKompen(String uuidKompen) async {
    try {
      final response = await _dio.put('$baseUrl/selesaikanKompen/$uuidKompen');
      if (response.statusCode != 200) {
        throw Exception('Gagal menyelesaikan kompen');
      }
    } catch (e) {
      throw Exception('Gagal menyelesaikan kompen: $e');
    }
  }

  Future<List<dynamic>> getKompenRequests(String ni) async {
    try {
      final response = await _dio.get('$baseUrl/kompen/requests/$ni');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Gagal mengambil data request kompen');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data request kompen: $e');
    }
  }

  Future<List<dynamic>> getKompenProgress(String ni) async {
    try {
      final response = await _dio.get('$baseUrl/view-progress-kompen/$ni');
      if (response.statusCode == 200) {
        return response.data['progress'];
      } else {
        throw Exception('Gagal mengambil data progress kompen');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data progress kompen: $e');
    }
  }
}
