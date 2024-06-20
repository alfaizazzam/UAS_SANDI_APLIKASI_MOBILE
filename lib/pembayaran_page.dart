import 'package:adamfaiz_finalproject_sandi/transaksi_page.dart';
import 'package:flutter/material.dart';
import 'firebase/firestore_service.dart';

class PembayaranPage extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  PembayaranPage({required this.orders});

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? selectedPaymentMethod;
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final totalHarga = widget.orders.fold(
      0,
      (sum, order) => sum + (order['hargaTiket'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.network(
                  widget.orders[0]['imageUrl'],
                  height: 50,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error, color: Colors.red),
                ),
                title: Text('Tiket Masuk ${widget.orders[0]['namaGunung']}'),
                subtitle: Text(
                    '${widget.orders[0]['jumlahAnggota']} Orang anggota rombongan'),
              ),
            ),
            SizedBox(height: 20),
            Text('Pilih Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Pilih Metode Pembayaran'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _showPaymentMethodDialog(),
            ),
            if (selectedPaymentMethod != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Metode Pembayaran: $selectedPaymentMethod',
                    style: TextStyle(color: Colors.green)),
              ),
            Spacer(),
            Text(
              'Total Harga: Rp $totalHarga',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedPaymentMethod == null
                  ? null
                  : () {
                      _showPaymentSuccessDialog(context, totalHarga);
                    },
              child:
                  Text('Bayar Sekarang', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildPaymentMethodTile('QRIS', 'assets/icons/qris.png'),
                    _buildPaymentMethodTile(
                        'ShopeePay', 'assets/icons/spay.png'),
                    _buildPaymentMethodTile('GoPay', 'assets/icons/gopay.png'),
                    _buildPaymentMethodTile('OVO', 'assets/icons/ovo.png'),
                    _buildPaymentMethodTile('Dana', 'assets/icons/dana.png'),
                  ],
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

  Widget _buildPaymentMethodTile(String method, String logoPath) {
    return ListTile(
      leading: Image.asset(
        logoPath,
        width: 40,
        height: 40,
      ),
      title: Text(method),
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, int totalHarga) {
    String paymentLogoPath;
    switch (selectedPaymentMethod) {
      case 'QRIS':
        paymentLogoPath = 'assets/icons/qris.png';
        break;
      case 'ShopeePay':
        paymentLogoPath = 'assets/icons/spay.png';
        break;
      case 'GoPay':
        paymentLogoPath = 'assets/icons/gopay.png';
        break;
      case 'OVO':
        paymentLogoPath = 'assets/icons/ovo.png';
        break;
      case 'Dana':
        paymentLogoPath = 'assets/icons/dana.png';
        break;
      default:
        paymentLogoPath = 'assets/icons/cash.png';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Selesaikan pembayaran'),
              SizedBox(height: 10),
              Image.asset(
                paymentLogoPath,
                height: 50,
                width: 50,
              ),
              SizedBox(height: 10),
              Text('Bayar menggunakan $selectedPaymentMethod',
                  style: TextStyle(color: Colors.green, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Pembayaran'),
              Text('Rp $totalHarga',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _deletePaidOrders(widget.orders);
                  Navigator.pop(context); // Menutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransaksiPage(),
                    ),
                  );
                },
                child: Text('Selesai', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePaidOrders(List<Map<String, dynamic>> orders) async {
    final batch = firestoreService.batch();
    for (var order in orders) {
      final docRef = firestoreService.getOrderDocRef(order['id']);
      batch.delete(docRef);
      await firestoreService.addTransactionHistory(order);
    }
    await batch.commit();
  }
}
