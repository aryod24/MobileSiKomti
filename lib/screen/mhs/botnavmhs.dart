import 'package:flutter/material.dart';

class BotNavMhs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BotNavMhs({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 113, 120, 158),
            Color.fromARGB(255, 65, 84, 129),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Kompen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timelapse), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Hasil'),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor:
            Colors.transparent, // Membuat latar belakang transparan
        selectedItemColor: Colors.white, // Warna untuk item yang dipilih
        unselectedItemColor:
            Colors.white70, // Warna untuk item yang tidak dipilih
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins'), // Gunakan Poppins untuk label yang dipilih
        unselectedLabelStyle: const TextStyle(
            fontFamily:
                'Poppins'), // Gunakan Poppins untuk label yang tidak dipilih
      ),
    );
  }
}
