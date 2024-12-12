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
        return []; // Return an empty list if the status code is not 200
      }
    } catch (e) {
      return []; // Return an empty list if there's an error
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
        return []; // Return an empty list if the response status code is not 200
      }
    } catch (e) {
      return []; // Return an empty list if an exception occurs
    }
  }

  Future<List<dynamic>> getKompenProgress(String ni) async {
    try {
      final response = await _dio.get('$baseUrl/view-progress-kompen/$ni');
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
