import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perkiraan Cuaca', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white), // Ikon menjadi putih
      ),
      body: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = '58ad0983d26786de748f108745d41064';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  List<Gunung> gunungs = [
    Gunung(
        nama: "Bromo",
        lintang: -7.942493,
        bujur: 112.953012,
        imageUrl: 'assets/gunung_bromo.jpg'),
    Gunung(
        nama: "Rinjani",
        lintang: -8.411634,
        bujur: 116.457712,
        imageUrl: 'assets/gunung_rinjani.jpg'),
    Gunung(
        nama: "Merbabu",
        lintang: -7.453611,
        bujur: 110.438056,
        imageUrl: 'assets/gunung_merbabu.jpg'),
    Gunung(
        nama: "Semeru",
        lintang: -8.1081,
        bujur: 112.9226,
        imageUrl: 'assets/gunung_semeru.jpg'),
    Gunung(
        nama: "Kerinci",
        lintang: -2.7661,
        bujur: 101.3084,
        imageUrl: 'assets/gunung_kerinci.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gunungs.length,
      itemBuilder: (context, index) {
        return KartuCuaca(gunung: gunungs[index], apiKey: apiKey);
      },
    );
  }
}

class KartuCuaca extends StatelessWidget {
  final Gunung gunung;
  final String apiKey;

  KartuCuaca({required this.gunung, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.blueAccent),
      ),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              gunung.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error, color: Colors.red),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                gunung.nama,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: Colors.grey.shade300),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GunungDetailPage(gunung: gunung, apiKey: apiKey),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Cuaca',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GunungDetailPage extends StatefulWidget {
  final Gunung gunung;
  final String apiKey;

  GunungDetailPage({required this.gunung, required this.apiKey});

  @override
  _GunungDetailPageState createState() => _GunungDetailPageState();
}

class _GunungDetailPageState extends State<GunungDetailPage> {
  String namaKota = '';
  String deskripsiCuaca = '';
  double suhu = 0.0;
  int kelembaban = 0;
  double kecepatanAngin = 0.0;
  String iconCode = '';
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    ambilCuaca();
  }

  Future<void> ambilCuaca() async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.gunung.lintang}&lon=${widget.gunung.bujur}&appid=${widget.apiKey}&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          namaKota = json['name'];
          deskripsiCuaca = json['weather'][0]['description'];
          suhu = json['main']['temp'];
          kelembaban = json['main']['humidity'];
          kecepatanAngin = json['wind']['speed'];
          iconCode = json['weather'][0]['icon'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Color getBackgroundColor(String description) {
    if (description.contains("rain")) {
      return Colors.blueGrey.shade800;
    } else if (description.contains("cloud")) {
      return Colors.blueGrey.shade600;
    } else if (description.contains("clear")) {
      return Colors.blue;
    } else if (description.contains("snow")) {
      return Colors.white;
    } else {
      return Colors.blueGrey.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cuaca ${widget.gunung.nama}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white), // Ikon menjadi putih
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Failed to load weather data'))
                : Container(
                    decoration: BoxDecoration(
                      color: getBackgroundColor(deskripsiCuaca),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          widget.gunung.nama,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Image.network(
                            'http://openweathermap.org/img/wn/$iconCode@2x.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$suhu°C',
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          deskripsiCuaca.toUpperCase(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          '${widget.gunung.lintang}, ${widget.gunung.bujur}',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.thermostat,
                                    color: Colors.red, size: 40),
                                Text('Suhu',
                                    style: TextStyle(color: Colors.white)),
                                Text('$suhu°C',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.water, color: Colors.blue, size: 40),
                                Text('Kelembaban',
                                    style: TextStyle(color: Colors.white)),
                                Text('$kelembaban%',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.air, color: Colors.white, size: 40),
                                Text('Angin',
                                    style: TextStyle(color: Colors.white)),
                                Text('$kecepatanAngin m/s',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class Gunung {
  final String nama;
  final double lintang;
  final double bujur;
  final String imageUrl;

  Gunung(
      {required this.nama,
      required this.lintang,
      required this.bujur,
      required this.imageUrl});
}
