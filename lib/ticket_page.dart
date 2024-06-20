import 'package:flutter/material.dart';
import 'firebase/firestore_service.dart';
import 'detail_ticket_page.dart';
import 'aturan_pendakian.dart';

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String selectedProvince = 'Semua Provinsi';
  String searchKeyword = '';
  bool isSearching = false;

  FirestoreService firestoreService = FirestoreService();
  List<Mountain> mountains = [];

  @override
  void initState() {
    super.initState();
    firestoreService.getMountains().listen((mountainList) {
      setState(() {
        mountains = mountainList;
      });
      print("Mountains loaded: ${mountains.length}");
    });
  }

  List<Mountain> get filteredMountains {
    List<Mountain> filteredByProvince = selectedProvince == 'Semua Provinsi'
        ? mountains
        : mountains
            .where((mountain) => mountain.province == selectedProvince)
            .toList();

    if (searchKeyword.isEmpty) {
      return filteredByProvince;
    } else {
      return filteredByProvince
          .where((mountain) =>
              mountain.name.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }
  }

  Set<String> get uniqueProvinces {
    Set<String> provinces = {'Semua Provinsi'};
    mountains.forEach((mountain) {
      provinces.add(mountain.province);
    });
    return provinces;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesan Tiket Masuk',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white), // Set arrow color to white
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search,
                color: Colors.white),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchKeyword = '';
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Nama Gunung',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchKeyword = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      label: Text("Filters",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        _showFilterDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMountains.length,
              itemBuilder: (context, index) {
                final mountain = filteredMountains[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MountainDetailPage(mountain: mountain),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                mountain.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                mountain.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mountain.location,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Table(
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      buildPriceInfo('Tarif Hari Kerja (WNI):',
                                          'Rp ${mountain.workDayPriceWNI}'),
                                      buildPriceInfo('Tarif Hari Libur (WNI):',
                                          'Rp ${mountain.holidayPriceWNI}'),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      buildPriceInfo('Tarif Hari Kerja (WNA):',
                                          'Rp ${mountain.workDayPriceWNA}'),
                                      buildPriceInfo('Tarif Hari Libur (WNA):',
                                          'Rp ${mountain.holidayPriceWNA}'),
                                    ],
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
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Filter Berdasarkan Provinsi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ...uniqueProvinces.map((province) {
                  return RadioListTile<String>(
                    title: Text(province),
                    value: province,
                    groupValue: selectedProvince,
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value!;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPriceInfo(String label, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class MountainDetailPage extends StatelessWidget {
  final Mountain mountain;

  MountainDetailPage({required this.mountain});

  @override
  Widget build(BuildContext context) {
    return AturanPendakianPage(
      mountainName: mountain.name,
      onConfirm: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTicketPage(mountain: mountain),
          ),
        );
      },
    );
  }
}
