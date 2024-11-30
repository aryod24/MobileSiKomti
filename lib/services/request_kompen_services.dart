import 'package:dio/dio.dart';

class RequestKompenService {
  final Dio dio = Dio();
  final String baseUrl = "http://192.168.1.14:8000/api/";

  // Fungsi untuk melakukan permintaan request kompen
  Future<bool> requestKompen(String uuidKompen, String ni, String nama) async {
    try {
      final response = await dio.post(
        "${baseUrl}kompen/request",
        data: {
          'UUID_Kompen': uuidKompen, // UUID kompen
          'nama': nama,
          'ni': ni, // Nomor induk mahasiswa
        },
      );

      // Cek status response
      if (response.statusCode == 201 && response.data['success'] == true) {
        return true;
      } else {
        // Mengembalikan pesan kesalahan dari respons jika ada
        print('${response.data['message']}');
        return false; // Kembalikan false jika gagal
      }
    } catch (e) {
      print('$e');
      return false; // Kembalikan false jika terjadi kesalahan
    }
  }

  // Fungsi untuk mengecek apakah request kompen sudah ada
  Future<bool> checkExistingRequest(String uuidKompen, String ni) async {
    try {
      final response = await dio.get(
        "${baseUrl}check-request",
        queryParameters: {
          'UUID_Kompen': uuidKompen,
          'ni': ni,
        },
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a flag 'exists' to indicate if the request exists
        return response.data['exists'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking existing request: $e');
      throw Exception('Gagal memeriksa permohonan yang sudah ada.');
    }
  }

  // Fungsi untuk mengecek pengajuan
  Future<Map<String, dynamic>> checkPengajuan(String uuid) async {
    try {
      final response = await dio.get("${baseUrl}kompen/request/$uuid");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Gagal memeriksa pengajuan');
      }
    } catch (e) {
      print('Error checking pengajuan: $e');
      throw Exception('Terjadi kesalahan saat memeriksa pengajuan');
    }
  }

  // Fungsi untuk mengecek progres
  Future<Map<String, dynamic>> checkProgress(String uuid) async {
    try {
      final response = await dio.get(
        "${baseUrl}kompen/check-progress",
        queryParameters: {
          'UUID_Kompen': uuid,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Gagal memeriksa progres');
      }
    } catch (e) {
      print('Error checking progress: $e');
      throw Exception('Terjadi kesalahan saat memeriksa progres');
    }
  }
}
