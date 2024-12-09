import 'package:flutter/material.dart';
import 'package:sikomti_mobile/screen/mhs/hasilscreenmhs.dart';
import 'package:sikomti_mobile/screen/mhs/progresskompen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_kompenmhs.dart';
import '../profil/profile_screen.dart';
import 'profilmhs.dart';
import 'botnavmhs.dart';

class MahasiswaScreen extends StatefulWidget {
  @override
  _MahasiswaScreenState createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text(
          'SiKomti',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
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
              size: 40,
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder<Map<String, String>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          } else {
            final userData = snapshot.data!;

            Widget bodyContent;
            switch (_selectedIndex) {
              case 0:
                bodyContent = HomepageContent(userData: userData);
                break;
              case 1:
                bodyContent = ListKompenScreen();
                break;
              case 2:
                bodyContent = ProgressKompenScreen();
                break;
              case 3:
                bodyContent = HasilScreenMahasiswa();
                break;
              default:
                bodyContent = Center(child: Text('Home Screen'));
            }

            return bodyContent;
          }
        },
      ),
      bottomNavigationBar: BotNavMhs(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomepageContent extends StatelessWidget {
  final Map<String, String> userData;

  HomepageContent({required this.userData});

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            ProfilMahasiswa(
              nama: userData['nama'] ?? 'Nama tidak ditemukan',
              ni: userData['ni'] ?? 'NI tidak ditemukan',
              jurusan: userData['jurusan'] ?? 'Jurusan tidak ditemukan',
            ),
            SizedBox(height: 20),
            // Button section
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildMenuButton(
                  icon: Icons.list_alt,
                  label: 'List\nPekerjaan',
                  onTap: () {
                    // Placeholder for navigation or action
                  },
                ),
                _buildMenuButton(
                  icon: Icons.assignment_turned_in,
                  label: 'Pengajuan\nKompen',
                  onTap: () {
                    // Placeholder for navigation or action
                  },
                ),
                _buildMenuButton(
                  icon: Icons.access_time,
                  label: 'Progres\nKompen',
                  onTap: () {
                    // Placeholder for navigation or action
                  },
                ),
                _buildMenuButton(
                  icon: Icons.assignment,
                  label: 'Hasil\nKompen',
                  onTap: () {
                    // Placeholder for navigation or action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
