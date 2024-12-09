import 'package:flutter/material.dart';

class BotNavDosen extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  BotNavDosen({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Latar belakang putih
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Data'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Kompen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Hasil'),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Warna latar belakang putih
        selectedItemColor:
            Color(0xFF00509E), // Warna item yang dipilih menjadi BIRU
        unselectedItemColor:
            Color.fromARGB(76, 0, 79, 158), // Warna item yang tidak dipilih
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins', // Font untuk label yang dipilih
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins', // Font untuk label yang tidak dipilih
        ),
      ),
    );
  }
}
