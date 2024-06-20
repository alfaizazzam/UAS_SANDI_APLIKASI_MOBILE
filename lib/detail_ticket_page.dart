import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firebase/firestore_service.dart';
import 'register_member_page.dart';

class DetailTicketPage extends StatefulWidget {
  final Mountain mountain;

  DetailTicketPage({required this.mountain});

  @override
  _DetailTicketPageState createState() => _DetailTicketPageState();
}

class _DetailTicketPageState extends State<DetailTicketPage> {
  DateTime? _selectedDate;
  int _jumlahAnggota = 0;
  String _selectedUserType = 'Pilih Tipe Pengguna';

  FirestoreService firestoreService = FirestoreService();

  bool get _isFormComplete {
    return _selectedDate != null &&
        _jumlahAnggota > 0 &&
        _selectedUserType != 'Pilih Tipe Pengguna';
  }

  bool get isWeekend {
    if (_selectedDate == null) return false;
    return _selectedDate!.weekday == DateTime.saturday ||
        _selectedDate!.weekday == DateTime.sunday;
  }

  int getTicketPrice() {
    if (_selectedUserType == 'Pilih Tipe Pengguna') {
      return 0;
    }
    if (_selectedUserType == 'WNI') {
      return isWeekend
          ? widget.mountain.holidayPriceWNI
          : widget.mountain.workDayPriceWNI;
    } else {
      return isWeekend
          ? widget.mountain.holidayPriceWNA
          : widget.mountain.workDayPriceWNA;
    }
  }

  Future<void> _saveBookingDetails() async {
    final bookingDetails = {
      'namaGunung': widget.mountain.name,
      'tipePengguna': _selectedUserType,
      'tanggalKeberangkatan': _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
      'jumlahAnggota': _jumlahAnggota,
      'hargaTiket': getTicketPrice(),
      'totalHarga': getTicketPrice() * _jumlahAnggota,
    };

    await firestoreService.addBookingDetails(bookingDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendakian ${widget.mountain.name}'),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.mountain.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.mountain.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.mountain.location,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(widget.mountain.description),
              SizedBox(height: 16),
              Text(
                'Tipe Pengguna',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _showUserTypeDialog,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: _selectedUserType,
                      suffixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Waktu Keberangkatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: _selectedDate == null
                          ? 'Pilih Tanggal'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Jumlah Anggota Rombongan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _showJumlahRombonganDialog,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: _jumlahAnggota == 0
                          ? 'Pilih Jumlah Rombongan'
                          : '$_jumlahAnggota',
                      suffixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isFormComplete) ...[
                SizedBox(height: 16),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga Tiket/Orang',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedUserType,
                                style: TextStyle(fontSize: 16)),
                            Text(
                              'Rp ${getTicketPrice()}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rincian Harga Tiket/Orang',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tarif ${_selectedUserType} Weekday',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Rp ${_selectedUserType == 'WNI' ? widget.mountain.workDayPriceWNI : widget.mountain.workDayPriceWNA}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tarif ${_selectedUserType} Weekend',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Rp ${_selectedUserType == 'WNI' ? widget.mountain.holidayPriceWNI : widget.mountain.holidayPriceWNA}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Calon pendaki diwajibkan untuk membaca dan mencermati SOP Pendakian yang sudah ditetapkan terlebih dahulu',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isFormComplete
                      ? () async {
                          await _saveBookingDetails();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterMemberPage(
                                jumlahAnggota: _jumlahAnggota,
                                dataPesanan: {
                                  'namaGunung': widget.mountain.name,
                                  'hargaTiket': getTicketPrice(),
                                  'tanggalKeberangkatan': _selectedDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_selectedDate!)
                                      : '',
                                  'members':
                                      [], // Akan diisi nanti di RegisterMemberPage
                                  'totalHarga':
                                      getTicketPrice() * _jumlahAnggota,
                                  'jumlahAnggota': _jumlahAnggota,
                                },
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text('Registrasi Calon Pendaki'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white, // Menjadikan tulisan putih
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Tipe Pengguna'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text('WNI'),
                  value: 'WNI',
                  groupValue: _selectedUserType,
                  onChanged: (value) {
                    setState(() {
                      _selectedUserType = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: Text('WNA'),
                  value: 'WNA',
                  groupValue: _selectedUserType,
                  onChanged: (value) {
                    setState(() {
                      _selectedUserType = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showJumlahRombonganDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return JumlahRombonganDialog(
          jumlahAnggota: _jumlahAnggota,
          onChanged: (value) {
            setState(() {
              _jumlahAnggota = value;
            });
          },
        );
      },
    );
  }
}

class JumlahRombonganDialog extends StatefulWidget {
  final int jumlahAnggota;
  final ValueChanged<int> onChanged;

  JumlahRombonganDialog({required this.jumlahAnggota, required this.onChanged});

  @override
  _JumlahRombonganDialogState createState() => _JumlahRombonganDialogState();
}

class _JumlahRombonganDialogState extends State<JumlahRombonganDialog> {
  late int _jumlahAnggota;

  @override
  void initState() {
    super.initState();
    _jumlahAnggota = widget.jumlahAnggota;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Jumlah Rombongan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jumlah Orang', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (_jumlahAnggota > 1) {
                          setState(() {
                            _jumlahAnggota--;
                          });
                        }
                      },
                    ),
                    Text('$_jumlahAnggota', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _jumlahAnggota++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onChanged(_jumlahAnggota);
                Navigator.of(context).pop();
              },
              child: Text('Terapkan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
