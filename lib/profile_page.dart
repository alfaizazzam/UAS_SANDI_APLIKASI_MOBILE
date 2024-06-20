import 'package:adamfaiz_finalproject_sandi/login_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  ProfilePage({this.user, User? currentUser});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginRegisterPage()),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tentang Aplikasi'),
          content: Text(
            'SANDI merupakan aplikasi pendakian gunung berbasis mobile yang sangat diharapkan. Aplikasi ini menyediakan layanan yang memudahkan perencanaan dan pelaksanaan pendakian dengan menghadirkan fitur-fitur yang sesuai dengan kebutuhan para pendaki. Dengan demikian, diharapkan dapat membantu mengurangi risiko kecelakaan dan memastikan keselamatan para pendaki.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E7D32),
        title: Text(
          'Profile',
          style:
              TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Ubah warna ikon panah menjadi putih
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage('assets/profile.png') as ImageProvider,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(user?.email ?? 'user@example.com'),
                ],
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Color(0xFF2E7D32)),
            title: Text('Tentang Aplikasi'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info,
                color: Color(
                    0xFF2E7D32)), // Updated to match the "Tentang Aplikasi" icon style
            title: Text('Tentang Kami'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.update, color: Color(0xFF2E7D32)),
            title: Text('Versi Aplikasi'),
            subtitle: Text('Ver 1.0.8#80'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(0xFF2E7D32)),
            title: Text('Keluar'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E7D32),
        title: Text(
          'Tentang Kami',
          style:
              TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Ubah warna ikon panah menjadi putih
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildProfileCard(
            'assets/Adam.jpg',
            'Adam Idhofi Rakasiwi',
            'Jln Kusuma Pasar Baru 1 No 17',
            '081999752814',
            'adamraka221@gmail.com',
            'https://github.com/AdamIdhofi',
          ),
          _buildProfileCard(
            'assets/faiz.jpg',
            'Al-Faiz Azzam Aryaputra',
            'Jln Sedayu 3 no 6, Surabaya',
            '082139148162',
            'alfaizazam@gmail.com',
            'https://github.com/alfaizazzam',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String imagePath, String name, String address,
      String phone, String email, String github) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(child: Text(address)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(phone),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: email,
                          );
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            throw 'Could not launch $email';
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child:
                              Text(email, style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.link, color: Colors.grey),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final Uri githubLaunchUri = Uri.parse(github);
                          if (await canLaunchUrl(githubLaunchUri)) {
                            await launchUrl(githubLaunchUri);
                          } else {
                            throw 'Could not launch $github';
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(github,
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
