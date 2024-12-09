import 'package:flutter/material.dart';
import 'kompen_detail_screen.dart'; // Import halaman detail kompen
import 'edit_kompen_screen.dart'; // Import halaman edit kompen

class PopupMenuKompen extends StatelessWidget {
  final String uuidKompen;
  final VoidCallback onDelete;

  PopupMenuKompen({required this.uuidKompen, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert, // Ikon titik tiga
        color: Colors.white, // Mengubah warna ikon menjadi putih
      ),
      onSelected: (value) {
        switch (value) {
          case 'detail':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    KompenDetailScreen(uuidKompen: uuidKompen),
              ),
            );
            break;
          case 'edit':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditKompenScreen(uuidKompen: uuidKompen),
              ),
            );
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'detail',
          child: Row(
            children: [
              Icon(Icons.remove_red_eye, color: Colors.blue),
              SizedBox(width: 10),
              const Text('Detail', style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 10),
              Text('Edit', style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 10),
              Text('Delete', style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ],
    );
  }
}
