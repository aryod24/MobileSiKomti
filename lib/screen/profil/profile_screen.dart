import 'package:flutter/material.dart';
import 'package:sikomti_mobile/services/auth_services.dart'; // Import AuthService for logout
import 'edit_user_screen.dart';
import '../../services/user_api_services.dart'; // Import UserApiService

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = ''; // Change userId to String
  String levelId = ''; // Change levelId to String
  String token = '';
  String username = '';
  String nama = '';
  String jurusan = '';
  String ni = '';

  final AuthService _authService = AuthService();
  final UserApiService _userApiService = UserApiService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await _userApiService.getUserProfile();
      setState(() {
        userId = userData['user_id'].toString(); // Ensure userId is a string
        levelId = userData['level_id'].toString(); // Ensure levelId is a string
        token = userData['token'] ?? '';
        username = userData['username'] ?? '';
        nama = userData['nama'] ?? '';
        jurusan = userData['jurusan'] ?? '';
        ni = userData['ni'] ?? '';
      });
    } catch (e) {
      // Handle error (e.g., show a message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout(context);
    // Show a snackbar message for logout information
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda telah logout'),
        duration: Duration(seconds: 2),
      ),
    );
    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget buildProfileCard(BuildContext context) {
    String nimOrInduk = '';

    // Conditionally set the value of 'NIM', 'NIDN', or 'Nomor Induk' based on levelId
    if (levelId == '2') {
      nimOrInduk = 'NIM: $ni'; // For level 2, show NIM
    } else if (levelId == '3') {
      nimOrInduk = 'NIDN: $ni'; // For level 3, show NIDN
    } else if (levelId == '4') {
      nimOrInduk = 'Nomor Induk: $ni'; // For level 4, show Nomor Induk
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            const Color.fromARGB(255, 113, 120, 158),
            Color.fromARGB(255, 65, 84, 129),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/image/profile.png'),
            ),
          ),
          const SizedBox(height: 5),
          // Displaying the NIM, NIDN, or Nomor Induk conditionally
          buildRichText('Nama', nama),
          buildDivider(),
          buildRichText(
              'Nomor Induk', nimOrInduk), // Dynamically setting the value
          buildDivider(),
          buildRichText('Username', username),
          buildDivider(),
          buildRichText('Jurusan', jurusan),
          buildDivider(),
          buildRichText('Password', '*********'),
        ],
      ),
    );
  }

  Widget buildRichText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const Divider(
        color: Colors.white,
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 113, 120, 158),
            Color.fromARGB(255, 65, 84, 129),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget buildHeaderCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Profil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
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
      backgroundColor:
          const Color(0xFFFEEFE5), // Set background color of the scaffold
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildHeaderCard(context),
              const SizedBox(height: 20),
              buildProfileCard(context),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: buildGradientButton(
                    'Edit Profil',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserScreen()),
                        )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: buildGradientButton('Logout', () => _logout()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
