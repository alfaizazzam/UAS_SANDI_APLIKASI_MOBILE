import 'package:flutter/material.dart';

class AturanPendakianPage extends StatefulWidget {
  final Function onConfirm;
  final String mountainName;

  AturanPendakianPage({required this.onConfirm, required this.mountainName});

  @override
  _AturanPendakianPageState createState() => _AturanPendakianPageState();
}

class _AturanPendakianPageState extends State<AturanPendakianPage> {
  bool isChecked = false;
  bool hasOpenedTataTertib = false;
  bool hasOpenedSyarat = false;
  bool hasOpenedLarangan = false;

  Map<String, Map<String, List<String>>> aturanPendakian = {
    'Gunung Bromo': {
      'Tata Tertib': [
        '1. Pendaki wajib mengisi form registrasi.',
        '2. Wajib meninggalkan identitas di pos jaga yang akan diambil saat turun.',
        '3. Pendaki wajib mengikuti briefing atau arahan petugas sebelum mendaki.',
        '4. Dilarang membuat jalur sendiri selama pendakian.',
        '5. Dilarang menggunakan kendaraan bermotor di jalur pendakian.',
      ],
      'Syarat': [
        '1. Wajib membawa surat izin dari Balai Besar Taman Nasional Bromo Tengger Semeru.',
        '2. Pendaki harus dalam kondisi sehat jasmani dan rohani.',
        '3. Usia minimal pendaki adalah 12 tahun, dan anak-anak harus didampingi oleh orang dewasa.',
        '4. Kelompok pendaki tidak boleh berjumlah ganjil.',
      ],
      'Larangan': [
        '1. Dilarang mendirikan tenda di area kawah atau lautan pasir.',
        '2. Dilarang membawa hewan peliharaan.',
        '3. Sampah wajib dibawa turun dan dibuang di tempat yang telah disediakan.',
        '4. Dilarang membuat api unggun di sepanjang jalur pendakian.',
        '5. Dilarang membunuh atau mengganggu satwa liar di sepanjang jalur.',
        '6. Dilarang membuat keributan atau melakukan aktivitas yang mengganggu ketertiban umum.',
        '7. Dilarang merusak fasilitas atau tanaman di area konservasi.',
        '8. Dilarang berfoto di tempat yang berbahaya.',
      ],
    },
    'Gunung Semeru': {
      'Tata Tertib': [
        '1. Pendaki wajib mengisi form registrasi dan mengikuti briefing dari petugas.',
        '2. Wajib meninggalkan identitas di pos Ranu Pani yang akan diambil saat turun.',
        '3. Dilarang mendaki ke puncak Mahameru di atas jam 12 siang.',
        '4. Dilarang membuat jalur sendiri atau memotong jalur resmi.',
      ],
      'Syarat': [
        '1. Wajib membawa surat izin masuk kawasan konservasi (SIMAKSI) dari Balai Besar Taman Nasional Bromo Tengger Semeru.',
        '2. Pendaki harus membawa surat keterangan sehat dari dokter.',
        '3. Usia minimal pendaki adalah 17 tahun atau didampingi oleh orang tua jika di bawah usia tersebut.',
        '4. Kelompok pendaki harus terdiri dari minimal 3 orang.',
      ],
      'Larangan': [
        '1. Dilarang mendirikan tenda di Ranu Kumbolo selain di area yang telah ditentukan.',
        '2. Dilarang membawa senjata tajam atau bahan peledak.',
        '3. Sampah wajib dibawa turun dan tidak boleh dibuang sembarangan.',
        '4. Dilarang membuat api unggun di sepanjang jalur pendakian.',
        '5. Dilarang memburu atau mengganggu satwa liar.',
        '6. Dilarang membuat keributan yang mengganggu ketertiban umum.',
        '7. Dilarang merusak fasilitas umum atau tanaman di area konservasi.',
        '8. Dilarang berfoto di tepi kawah yang berbahaya.',
      ],
    },
    'Gunung Kerinci': {
      'Tata Tertib': [
        '1. Pendaki wajib mengisi form registrasi di pos pendakian Kersik Tuo.',
        '2. Wajib meninggalkan identitas di pos yang akan diambil saat turun.',
        '3. Pendaki wajib mengikuti briefing atau arahan petugas sebelum memulai pendakian.',
        '4. Dilarang mendaki sendirian, minimal dalam kelompok dua orang.',
      ],
      'Syarat': [
        '1. Wajib membawa surat izin dari Balai Taman Nasional Kerinci Seblat.',
        '2. Pendaki harus membawa surat keterangan sehat dari dokter.',
        '3. Usia minimal pendaki adalah 15 tahun, anak-anak harus didampingi oleh orang dewasa.',
        '4. Kelompok pendaki harus berjumlah genap.',
      ],
      'Larangan': [
        '1. Dilarang mendirikan tenda di area puncak dan shelter 3.',
        '2. Dilarang membawa alat musik atau sound system yang mengganggu.',
        '3. Sampah wajib dibawa turun dan dibuang di tempat yang telah disediakan.',
        '4. Dilarang membuat api unggun di sepanjang jalur pendakian.',
        '5. Dilarang merusak atau mengambil tanaman di sepanjang jalur.',
        '6. Dilarang memburu atau mengganggu satwa liar.',
        '7. Dilarang membuat keributan atau melakukan aktivitas yang mengganggu ketertiban umum.',
        '8. Dilarang berfoto di tempat yang berbahaya.',
      ],
    },
    'Gunung Rinjani': {
      'Tata Tertib': [
        '1. Pendaki wajib mengisi form registrasi di pos pendakian Senaru atau Sembalun.',
        '2. Wajib meninggalkan identitas di pos yang akan diambil saat turun.',
        '3. Pendaki wajib mengikuti briefing atau arahan petugas sebelum mendaki.',
        '4. Dilarang membuat jalur sendiri selama pendakian.',
      ],
      'Syarat': [
        '1. Wajib membawa surat izin dari Taman Nasional Gunung Rinjani.',
        '2. Pendaki harus membawa surat keterangan sehat dari dokter.',
        '3. Usia minimal pendaki adalah 18 tahun.',
        '4. Kelompok pendaki harus terdiri dari minimal 2 orang.',
      ],
      'Larangan': [
        '1. Dilarang mendirikan tenda di area puncak dan Danau Segara Anak tanpa izin.',
        '2. Dilarang membawa alkohol atau narkoba.',
        '3. Sampah wajib dibawa turun dan tidak boleh dibuang sembarangan.',
        '4. Dilarang membuat api unggun di sepanjang jalur pendakian.',
        '5. Dilarang memburu atau mengganggu satwa liar.',
        '6. Dilarang membuat keributan yang mengganggu ketertiban umum.',
        '7. Dilarang merusak fasilitas umum atau tanaman di area konservasi.',
        '8. Dilarang berfoto di tepi kawah yang berbahaya.',
      ],
    },
    'Gunung Merbabu': {
      'Tata Tertib': [
        '1. Pendaki wajib mengisi form registrasi di pos pendakian Selo atau Thekelan.',
        '2. Wajib meninggalkan identitas di pos yang akan diambil saat turun.',
        '3. Pendaki wajib mengikuti briefing atau arahan petugas sebelum memulai pendakian.',
        '4. Dilarang membuat jalur sendiri selama pendakian.',
      ],
      'Syarat': [
        '1. Wajib membawa surat izin dari Balai Taman Nasional Gunung Merbabu.',
        '2. Pendaki harus membawa surat keterangan sehat dari dokter.',
        '3. Usia minimal pendaki adalah 16 tahun, anak-anak harus didampingi oleh orang dewasa.',
        '4. Kelompok pendaki tidak boleh berjumlah ganjil.',
      ],
      'Larangan': [
        '1. Dilarang mendirikan tenda di area sabana tanpa izin.',
        '2. Dilarang membawa alat musik atau sound system yang mengganggu.',
        '3. Sampah wajib dibawa turun dan dibuang di tempat yang telah disediakan.',
        '4. Dilarang membuat api unggun di sepanjang jalur pendakian.',
        '5. Dilarang merusak atau mengambil tanaman di sepanjang jalur.',
        '6. Dilarang memburu atau mengganggu satwa liar.',
        '7. Dilarang membuat keributan atau melakukan aktivitas yang mengganggu ketertiban umum.',
        '8. Dilarang berfoto di tempat yang berbahaya.',
      ],
    },
  };

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Peringatan'),
        content: Text('Anda harus membuka semua bagian terlebih dahulu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> aturanPendakianGunung =
        aturanPendakian[widget.mountainName] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Aturan Pendakian ${widget.mountainName}'),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Arrow color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: aturanPendakianGunung.keys.length,
                itemBuilder: (context, index) {
                  String key = aturanPendakianGunung.keys.elementAt(index);
                  List<String> items = aturanPendakianGunung[key]!;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        key,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          if (key == 'Tata Tertib') {
                            hasOpenedTataTertib = expanded;
                          } else if (key == 'Syarat') {
                            hasOpenedSyarat = expanded;
                          } else if (key == 'Larangan') {
                            hasOpenedLarangan = expanded;
                          }
                        });
                      },
                      children: items.map((item) {
                        bool isBold = item.endsWith(':');
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isBold ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      if (hasOpenedTataTertib &&
                          hasOpenedSyarat &&
                          hasOpenedLarangan) {
                        setState(() {
                          isChecked = value!;
                        });
                      } else {
                        _showWarningDialog();
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Saya telah membaca, menyetujui, dan bersedia mengikuti semua peraturan SOP yang berlaku.',
                      style: TextStyle(color: Color(0xFF1B5E20)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: isChecked
                    ? () {
                        widget.onConfirm();
                      }
                    : null,
                child: Text(
                  'Selanjutnya',
                  style: TextStyle(color: Colors.white), // Set text to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
