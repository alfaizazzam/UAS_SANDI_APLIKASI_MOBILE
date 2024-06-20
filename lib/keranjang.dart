import 'package:adamfaiz_finalproject_sandi/ticket_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase/firestore_service.dart';
import 'pembayaran_page.dart'; // Import halaman pembayaran

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  FirestoreService firestoreService = FirestoreService();
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    firestoreService.getOrders().listen((orderList) async {
      List<Map<String, dynamic>> updatedOrders = [];
      for (var order in orderList) {
        String imageUrl = order['imageUrl'] ?? '';
        if (imageUrl.isEmpty) {
          imageUrl = await firestoreService
              .getImageUrlByMountainName(order['namaGunung']);
        }
        updatedOrders.add({
          'id': order['id'] ?? '',
          'namaGunung': order['namaGunung'] ?? '',
          'imageUrl': imageUrl,
          'jumlahAnggota': order['jumlahAnggota'] ?? 0,
          'hargaTiket': order['hargaTiket'] ?? 0,
          'tanggalKeberangkatan': order['tanggalKeberangkatan'] ?? '',
          'members': order['members'] ?? [],
          'totalHarga': order['totalHarga'] ?? 0,
          'selected': order['selected'] ?? false,
        });
      }
      setState(() {
        orders = updatedOrders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Keranjang Kosong',
                      style: TextStyle(color: Colors.black)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TicketPage()));
                    },
                    child: Text('Pesan Tiket',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: order['selected'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  order['selected'] = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order['namaGunung'] ?? ''),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Image.network(
                                        order['imageUrl'],
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error,
                                                    color: Colors.red),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Tiket ${order['namaGunung']}'),
                                          Text(
                                              'Jumlah Rombongan: ${order['jumlahAnggota']}'),
                                          Text('Rp ${order['hargaTiket']}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    firestoreService.deleteOrder(order['id']);
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDetailModal(context, order);
                                  },
                                  child: Text('Lihat Detail',
                                      style:
                                          TextStyle(color: Color(0xFF2E7D32))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Harga: Rp ${calculateTotalPrice()}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              ElevatedButton(
                onPressed: orders.any((order) => order['selected'] == true)
                    ? () {
                        final selectedOrders = orders
                            .where((order) => order['selected'] == true)
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PembayaranPage(orders: selectedOrders),
                          ),
                        );
                      }
                    : null, // Tombol dinonaktifkan jika tidak ada pesanan yang dichecklist
                child: Text('Checkout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int calculateTotalPrice() {
    return orders
        .where((order) => order['selected'] == true)
        .fold(0, (sum, order) => sum + (order['hargaTiket'] as int));
  }

  void showDetailModal(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return VerifikasiPesananContent(dataPesanan: order);
      },
    );
  }
}

class VerifikasiPesananContent extends StatelessWidget {
  final Map<String, dynamic> dataPesanan;
  final FirestoreService _firestoreService = FirestoreService();

  VerifikasiPesananContent({required this.dataPesanan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailPesananCard(context),
            SizedBox(height: 20),
            buildDataRombonganCard(context),
            SizedBox(height: 20),
            buildRincianHargaCard(context),
          ],
        ),
      ),
    );
  }

  Widget buildDetailPesananCard(BuildContext context) {
    final String namaGunung = dataPesanan['namaGunung'] ?? '';

    return FutureBuilder<QuerySnapshot>(
      future: _firestoreService.getMountainByName(namaGunung),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error occurred while fetching data.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Data not available'));
        }

        final doc = snapshot.data!.docs.first;
        final mountain = Mountain.fromFirestore(doc);

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      mountain.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tiket ${mountain.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildDetailItem('Jumlah Rombongan',
                    (dataPesanan['jumlahAnggota'] ?? 'N/A').toString()),
                buildDetailItem('Tanggal Keberangkatan ',
                    dataPesanan['tanggalKeberangkatan'] ?? 'N/A'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDataRombonganCard(BuildContext context) {
    final List<dynamic> members = dataPesanan['members'] ?? [];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Data Rombongan'),
            SizedBox(height: 10),
            if (members.isNotEmpty) ...[
              buildDetailItem(
                  'Ketua Rombongan', members[0]['namaAnggota'] ?? 'N/A'),
              buildDetailItem('No. Telepon', members[0]['noTelepon'] ?? 'N/A'),
              buildDetailItem('Alamat Email', members[0]['email'] ?? 'N/A'),
            ] else ...[
              buildDetailItem('Ketua Rombongan', 'N/A'),
              buildDetailItem('No. Telepon', 'N/A'),
              buildDetailItem('Alamat Email', 'N/A'),
            ],
            InkWell(
              onTap: () {
                // Panggil fungsi untuk menampilkan data lengkap
                showCompleteMemberDetails(context, members);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selengkapnya',
                      style: TextStyle(color: Color(0xFF2E7D32)),
                    ),
                    Icon(Icons.arrow_forward, color: Color(0xFF2E7D32)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCompleteMemberDetails(BuildContext context, List<dynamic> members) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Lengkap Rombongan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final isKetua =
                        index == 0; // Asumsikan ketua adalah anggota pertama
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDetailItem(
                                isKetua ? 'Nama Ketua' : 'Nama Anggota',
                                member['namaAnggota'] ?? 'N/A'),
                            buildDetailItem('No. Identitas',
                                member['noIdentitas'] ?? 'N/A'),
                            buildDetailItem(
                                'No. Telepon', member['noTelepon'] ?? 'N/A'),
                            buildDetailItem('Kewarganegaraan',
                                member['kewarganegaraan'] ?? 'N/A'),
                            buildDetailItem('Jenis Kelamin',
                                member['jenisKelamin'] ?? 'N/A'),
                            if (member['riwayatPenyakit'] != null &&
                                member['riwayatPenyakit'].isNotEmpty)
                              buildDetailItem(
                                  'Riwayat Penyakit',
                                  (member['riwayatPenyakit'] as List<dynamic>)
                                      .join(', ')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tutup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRincianHargaCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Rincian Harga'),
            SizedBox(height: 10),
            buildDetailItem(
                'Harga Tiket', 'Rp ${dataPesanan['hargaTiket'] ?? 'N/A'}'),
            buildDetailItem(
                'Subtotal', 'Rp ${dataPesanan['hargaTiket'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Divider(),
            buildTotalPriceItem(
                'Jumlah Total', 'Rp ${dataPesanan['totalHarga'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalPriceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
