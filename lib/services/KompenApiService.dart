import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KompenApiService {
  Dio dio = Dio();
  final String baseUrl = "http://192.168.1.14:8000/api/";

  Future<List<dynamic>> getKompenList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final response = await dio.get(
      baseUrl + "kompen",
      queryParameters: {
        'user_id': userId
      }, // Menambahkan user_id sebagai query parameter
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Gagal mengambil data kompen');
    }
  }

  Future<List<dynamic>> getKompenListAll() async {
    final response = await dio.get(baseUrl + "kompen");

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Gagal mengambil data kompen');
    }
  }

  Future<Map<String, dynamic>> createKompen(
      Map<String, dynamic> kompenData) async {
    try {
      final response = await dio.post(baseUrl + "kompen", data: kompenData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Gagal menambahkan kompen');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Map<String, dynamic>> getKompenDetail(String uuidKompen) async {
    final response = await dio.get(baseUrl + "kompen/$uuidKompen");
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Gagal mengambil detail kompen');
    }
  }

  // Mendapatkan data kompen berdasarkan UUID
  Future<Map<String, dynamic>?> getKompenById(String uuid) async {
    try {
      final response = await dio.get(baseUrl + "kompen/$uuid");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Failed to load kompen data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Memperbarui data kompen berdasarkan UUID
  Future<bool> updateKompen(String uuid, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(baseUrl + "kompen/$uuid", data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update kompen data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> deleteKompen(String uuid) async {
    try {
      final response = await dio.delete(baseUrl + "kompen/$uuid");
      return response.data;
    } catch (e) {
      throw Exception('Gagal menghapus kompen: $e');
    }
  }

  // Request kompen
  Future<bool> requestKompen(String uuidKompen, String ni) async {
    try {
      final response = await dio.post(
        baseUrl + "kompen/request",
        data: {
          'UUID_Kompen': uuidKompen,
          'ni': ni,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        print('Request failed: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
