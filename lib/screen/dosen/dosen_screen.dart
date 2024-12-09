import 'package:flutter/material.dart';
import 'package:sikomti_mobile/screen/dosen/hasilscreen.dart';
import 'package:sikomti_mobile/screen/dosen/requestmhs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kompen/create_kompen_screen.dart';
import 'kompen_screen.dart';
import '../profil/profile_screen.dart';
import 'botnav_dsn.dart';
import 'profildsn.dart';
import 'data_screen.dart';

class DosenScreen extends StatefulWidget {
  @override
  _DosenScreenState createState() => _DosenScreenState();
}

class _DosenScreenState extends State<DosenScreen> {
  int _selectedIndex = 0;

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString('user_id') ?? '',
      'level_id': prefs.getString('level_id') ?? '',
      'ni': prefs.getString('ni') ?? '',
      'token': prefs.getString('token') ?? '',
      'username': prefs.getString('username') ?? '',
      'nama': prefs.getString('nama') ?? '',
      'jurusan': prefs.getString('jurusan') ?? '',
    };
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage(Map<String, String> userData) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white, // Latar belakang putih
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1),
            ProfilDosen(
              nama: userData['nama'] ?? 'Nama tidak ditemukan',
              ni: userData['ni'] ?? 'NI tidak ditemukan',
              jurusan: userData['jurusan'] ?? 'Jurusan tidak ditemukan',
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                width: 400,
                child: Card(
                  elevation: 4,
                  color: Color(0xFF002366), // Warna biru header
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Teks putih
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuButton(
                    icon: Icons.add_circle_outline,
                    label: 'Tambah\nPekerjaan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateKompenScreen()),
                    ),
                  ),
                  _buildMenuButton(
                    icon: Icons.list_alt,
                    label: 'List\nPekerjaan',
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  _buildMenuButton(
                    icon: Icons.school,
                    label: 'Mahasiswa\nAlpha',
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  _buildMenuButton(
                    icon: Icons.assignment_turned_in,
                    label: 'Pengajuan\nKompen',
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),
                  _buildMenuButton(
                    icon: Icons.access_time,
                    label: 'Progres\nKompen',
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),
                  _buildMenuButton(
                    icon: Icons.assignment,
                    label: 'Hasil\nKompen',
                    onTap: () => setState(() => _selectedIndex = 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Biru seperti pada gambar
        elevation: 0,
        title: Text(
          'SiKomti',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: const Color.fromARGB(255, 0, 0, 0), // Teks putih
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/image/logonew.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Latar belakang putih
      body: FutureBuilder<Map<String, String>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          } else {
            final userData = snapshot.data!;

            return IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomePage(userData),
                DataScreen(),
                KompenScreen(),
                RequestMhsScreen(),
                HasilScreenDosen(),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BotNavDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: 'menu_button_$label', // Gunakan label untuk tag unik
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF00509E), // Warna biru menu
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
