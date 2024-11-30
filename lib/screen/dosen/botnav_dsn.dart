import 'package:flutter/material.dart';

class BotNavDosen extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  BotNavDosen({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Data'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Kompen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Hasil'),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor:
            Colors.transparent, // Membuat latar belakang transparan
        selectedItemColor: Colors.white, // Warna untuk item yang dipilih
        unselectedItemColor:
            Colors.white70, // Warna untuk item yang tidak dipilih
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            TextStyle(fontFamily: 'Poppins'), // Use Poppins for selected label
        unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins'), // Use Poppins for unselected label
      ),
    );
  }
}
