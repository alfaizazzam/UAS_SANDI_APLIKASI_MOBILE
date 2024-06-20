import 'package:adamfaiz_finalproject_sandi/firebase/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'mountain_info_page.dart';
import 'ticket_page.dart';
import 'weather_page.dart';
import 'checklist_page.dart';
import 'profile_page.dart';
import 'splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase/firestore_service.dart';
import 'keranjang.dart';
import 'transaksi_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi data lokal untuk 'id_ID'
  await initializeDateFormatting('id_ID', null);

  // Tambahkan data gunung ke Firestore jika belum ada
  FirestoreService firestoreService = FirestoreService();
  bool dataExists = await firestoreService.checkIfDataExists();
  if (!dataExists) {
    await firestoreService.addMountains(mountains);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  User? _currentUser;
  int _unprocessedOrdersCount = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirestoreService firestoreService = FirestoreService();
    firestoreService.getOrders().listen((orderList) {
      setState(() {
        _unprocessedOrdersCount = orderList.length;
      });
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    TransaksiPage(),
    ProfilePage(user: FirebaseAuth.instance.currentUser),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions[_selectedIndex],
          if (_selectedIndex == 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: 175,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/logo_2.png',
                                height: 50, // Adjust logo size
                              ),
                              SizedBox(width: 10),
                              Text(
                                'SANDI (Sahabat Pendaki Indonesia)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KeranjangPage()),
                                      );
                                    },
                                  ),
                                  if (_unprocessedOrdersCount > 0)
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 20,
                                          minHeight: 20,
                                        ),
                                        child: Text(
                                          '$_unprocessedOrdersCount',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.notifications,
                                    color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Adjust the spacing here
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/profile.png'), // Profile image
                                    radius: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Halo ${_currentUser?.displayName ?? "Pendaki"}, mau mendaki kemana besok?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF2E7D32),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.8);
  int _currentPage = 1;
  Timer? _timer;

  final List<String> _bannerImages = [
    'assets/banner_sandi.png',
    'assets/banner_cuaca.png',
    'assets/banner_check.png',
    'assets/banner_tiket.png',
    'assets/banner_artikel.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _bannerImages.length + 1) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 1;
        });
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 200,
          left: 16.0,
          right: 16.0,
        ), // Adjusted padding for the main content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 160, // Height of the banner container
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      if (page == 0) {
                        _pageController.jumpToPage(_bannerImages.length);
                      } else if (page == _bannerImages.length + 1) {
                        _pageController.jumpToPage(1);
                      } else {
                        setState(() {
                          _currentPage = page;
                        });
                      }
                    },
                    itemCount: _bannerImages.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return BannerImage(
                            image: _bannerImages[_bannerImages.length - 1]);
                      } else if (index == _bannerImages.length + 1) {
                        return BannerImage(image: _bannerImages[0]);
                      } else {
                        return BannerImage(image: _bannerImages[index - 1]);
                      }
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_bannerImages.length,
                          (index) => buildDot(index, context)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Services
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ServiceItem(
                  iconPath: 'assets/icons/artikel.png',
                  label: 'Artikel Gunung',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MountainInfoPage()),
                    );
                  },
                ),
                ServiceItem(
                  iconPath: 'assets/icons/tiket.png',
                  label: 'Tiket Masuk',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TicketPage()),
                    );
                  },
                ),
                ServiceItem(
                  iconPath: 'assets/icons/cuaca.png',
                  label: 'Perkiraan Cuaca',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherPage()),
                    );
                  },
                ),
                ServiceItem(
                  iconPath: 'assets/icons/checklist.png',
                  label: 'Checklist Barang',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChecklistPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Mountains List
            Text('Gunung Populer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  MountainCard(
                    image: 'assets/gunung_merbabu.jpg',
                    title: 'Gunung Merbabu',
                    location: 'Jawa Tengah, Indonesia',
                  ),
                  MountainCard(
                    image: 'assets/gunung_semeru.jpg',
                    title: 'Gunung Semeru',
                    location: 'Jawa Timur, Indonesia',
                  ),
                  MountainCard(
                    image: 'assets/gunung_bromo.jpg',
                    title: 'Gunung Bromo',
                    location: 'Jawa Timur, Indonesia',
                  ),
                  MountainCard(
                    image: 'assets/gunung_kerinci.png',
                    title: 'Gunung Kerinci',
                    location: 'Sumatera Barat, Indonesia',
                  ),
                  MountainCard(
                    image: 'assets/gunung_rinjani.jpg',
                    title: 'Gunung Rinjani',
                    location: 'Lombok, Indonesia',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: _currentPage == index + 1 ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index + 1 ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class BannerImage extends StatelessWidget {
  final String image;

  BannerImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover, // Ensure the image covers the container
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final Function onTap;

  ServiceItem(
      {required this.iconPath, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFC8E6C9),
              borderRadius: BorderRadius.circular(10), // Rounded square
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                height: 24,
                width: 24,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class MountainCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;

  MountainCard(
      {required this.image, required this.title, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
