import 'package:flutter/material.dart';

class ProfilDosen extends StatelessWidget {
  final String nama;
  final String ni;
  final String jurusan;

  ProfilDosen({required this.nama, required this.ni, required this.jurusan});

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
              Color.fromARGB(255, 113, 120, 158),
              Color.fromARGB(255, 65, 84, 129),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Informasi Profil Dosen
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama, // Nama dosen
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  'NIP: $ni',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  jurusan, // Jurusan dosen
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            // Logo Dosen di sebelah kanan
            Image.asset(
              'assets/image/teach.png', // ganti dengan path logo yang sesuai
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
