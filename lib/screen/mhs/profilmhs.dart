import 'package:flutter/material.dart';

class ProfilMahasiswa extends StatelessWidget {
  final String nama;
  final String ni;
  final String jurusan;

  ProfilMahasiswa(
      {required this.nama, required this.ni, required this.jurusan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00509E),
              Color(0xFF002366),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Informasi Profil Mahasiswa
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama, // Nama mahasiswa
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  'NIM: $ni', // NIM mahasiswa
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  jurusan, // Jurusan mahasiswa
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            // Logo Mahasiswa di sebelah kanan
            Image.asset(
              'assets/image/student.png', // ganti dengan path logo yang sesuai
              width: 60,
              height: 60,
              color: Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
          ],
        ),
      ),
    );
  }
}