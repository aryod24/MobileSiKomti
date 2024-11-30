import 'package:dio/dio.dart';
import '../models/mahasiswa_alpha.dart';

class DataService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.14:8000/api/',
    ),
  );

  Future<List<MahasiswaAlpha>> fetchMahasiswaAlpha() async {
    try {
      final response = await _dio.get('/alpha');
      return (response.data as List)
          .map((item) => MahasiswaAlpha.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> createMahasiswaAlpha(
      MahasiswaAlpha mahasiswaAlpha) async {
    try {
      final response = await _dio.post('/alpha', data: mahasiswaAlpha.toJson());
      return response.data;
    } catch (e) {
      throw Exception('Failed to create data');
    }
  }

  Future<Map<String, dynamic>> updateMahasiswaAlpha(
      MahasiswaAlpha mahasiswaAlpha) async {
    try {
      final response = await _dio.put('/alpha/${mahasiswaAlpha.idAlpha}',
          data: mahasiswaAlpha.toJson());
      return response.data;
    } catch (e) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteMahasiswaAlpha(int idAlpha) async {
    try {
      await _dio.delete('/alpha/$idAlpha');
    } catch (e) {
      throw Exception('Failed to delete data');
    }
  }

  Future<List<MahasiswaAlpha>> fetchMahasiswaAlphaByNi(String ni) async {
    try {
      final response = await _dio.get('/alpha/ni/$ni');
      return (response.data as List)
          .map((item) => MahasiswaAlpha.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load data by NI');
    }
  }
}
