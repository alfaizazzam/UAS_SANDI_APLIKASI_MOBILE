import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firebase/firestore_service.dart';

class TransaksiPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Transaksi',
          style:
              TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Ubah warna ikon panah menjadi putih
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getTransactionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada riwayat transaksi.'));
          }
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                  .format(DateTime.parse(transaction['tanggalTransaksi'])
                      .toLocal()); // Format tanggal
              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () => _showTransactionDetails(context, transaction),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pembelian $formattedDate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                transaction['imageUrl'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tiket ${transaction['namaGunung']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${transaction['jumlahAnggota']} anggota rombongan',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Tanggal Keberangkatan: ${transaction['tanggalKeberangkatan']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Total Pembayaran: Rp ${transaction['hargaTiket']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Status: Pembayaran Berhasil',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTransactionDetails(
      BuildContext context, Map<String, dynamic> transaction) {
    final qrUrl =
        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${transaction['id']}'; // Pastikan ID unik digunakan di sini
    final formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
        .format(DateTime.parse(transaction['tanggalTransaksi']).toLocal());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    qrUrl,
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, color: Colors.red),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Detail Pembelian',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Tanggal Transaksi: $formattedDate',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Nama Gunung: ${transaction['namaGunung']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Jumlah Anggota: ${transaction['jumlahAnggota']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Nama Ketua Rombongan: ${transaction['members'][0]['namaAnggota']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Tanggal Keberangkatan: ${transaction['tanggalKeberangkatan']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Total Pembayaran: Rp ${transaction['hargaTiket']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Tutup'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
