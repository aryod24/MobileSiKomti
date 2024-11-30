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
        backgroundColor: Color(0xFFFED7C3),
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
              color: Colors.black,
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
      backgroundColor: Color(0xFFFEEFE5),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFED7C3), Color(0xFFFEEFE5)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1),
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selamat datang di SiKomti',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ProfilMahasiswa(
              nama: userData['nama'] ?? 'Nama tidak ditemukan',
              ni: userData['ni'] ?? 'NI tidak ditemukan',
              jurusan: userData['jurusan'] ?? 'Jurusan tidak ditemukan',
            ),
          ],
        ),
      ),
    );
  }
}
