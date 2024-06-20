import 'package:flutter/material.dart';
import 'firebase/firestore_service.dart';
import 'verifikasi_pesanan.dart';

class RegisterMemberPage extends StatefulWidget {
  final int jumlahAnggota;
  final Map<String, dynamic> dataPesanan;

  RegisterMemberPage({required this.jumlahAnggota, required this.dataPesanan});

  @override
  _RegisterMemberPageState createState() => _RegisterMemberPageState();
}

class _RegisterMemberPageState extends State<RegisterMemberPage> {
  final List<Map<String, dynamic>> _members = [];
  final TextEditingController _namaAnggotaController = TextEditingController();
  final TextEditingController _noIdentitasController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<TextEditingController> _riwayatPenyakitControllers = [];

  String _selectedJenisAnggota = 'Anggota';
  String _selectedKewarganegaraan = 'WNI';
  String _selectedJenisKelamin = 'Laki - Laki';
  bool _isFormVisible = false;
  bool _isEditing = false;
  int _editingIndex = -1;

  FirestoreService firestoreService = FirestoreService();

  void _addMember() {
    if (_validateInputs()) {
      setState(() {
        final newMember = {
          'jenisAnggota': _selectedJenisAnggota,
          'kewarganegaraan': _selectedKewarganegaraan,
          'namaAnggota': _namaAnggotaController.text,
          'noIdentitas': _noIdentitasController.text,
          'noTelepon': _noTeleponController.text,
          'email': _emailController.text,
          'jenisKelamin': _selectedJenisKelamin,
          'riwayatPenyakit': _riwayatPenyakitControllers
              .map((controller) => controller.text)
              .toList(),
        };

        if (_isEditing) {
          _members[_editingIndex] = newMember;
          _isEditing = false;
          _editingIndex = -1;
        } else {
          if (_selectedJenisAnggota == 'Ketua Rombongan' &&
              _members.any(
                  (member) => member['jenisAnggota'] == 'Ketua Rombongan')) {
            _showErrorDialog('Ketua Rombongan sudah ada.');
            return;
          }

          _members.add(newMember);
          _updateMemberOrder();
        }

        _clearForm();
        _isFormVisible = false;
      });
    }
  }

  void _clearForm() {
    _namaAnggotaController.clear();
    _noIdentitasController.clear();
    _noTeleponController.clear();
    _emailController.clear();
    _riwayatPenyakitControllers.clear();
  }

  String _getNextMemberLabel() {
    int count = _members
            .where((member) => member['jenisAnggota'] != 'Ketua Rombongan')
            .length +
        1;
    return 'Anggota $count';
  }

  bool _validateInputs() {
    if (_namaAnggotaController.text.isEmpty ||
        _noIdentitasController.text.isEmpty ||
        _noTeleponController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _showErrorDialog('Semua bidang harus diisi.');
      return false;
    }

    if (!_isNumeric(_noIdentitasController.text)) {
      _showErrorDialog('Nomor Identitas harus berupa angka.');
      return false;
    }

    if (!_isNumeric(_noTeleponController.text)) {
      _showErrorDialog('Nomor Telepon harus berupa angka.');
      return false;
    }

    if (!_emailController.text.contains('@gmail.com')) {
      _showErrorDialog('Email harus valid dan mengandung @gmail.com.');
      return false;
    }

    return true;
  }

  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editMember(int index) {
    setState(() {
      final member = _members[index];
      _namaAnggotaController.text = member['namaAnggota'];
      _noIdentitasController.text = member['noIdentitas'];
      _noTeleponController.text = member['noTelepon'];
      _emailController.text = member['email'];
      _selectedJenisAnggota = member['jenisAnggota'];
      _selectedKewarganegaraan = member['kewarganegaraan'];
      _selectedJenisKelamin = member['jenisKelamin'];

      _riwayatPenyakitControllers.clear();
      for (var penyakit in member['riwayatPenyakit']) {
        _riwayatPenyakitControllers.add(TextEditingController(text: penyakit));
      }

      _isFormVisible = true;
      _isEditing = true;
      _editingIndex = index;
    });
  }

  void _removeRiwayatPenyakit(int index) {
    setState(() {
      _riwayatPenyakitControllers.removeAt(index);
    });
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
      _updateMemberOrder(); // Update the order to reassign the member numbers
    });
  }

  void _updateMemberOrder() {
    setState(() {
      final ketuaReguIndex = _members
          .indexWhere((member) => member['jenisAnggota'] == 'Ketua Rombongan');
      if (ketuaReguIndex != -1) {
        final ketuaRegu = _members.removeAt(ketuaReguIndex);
        _members.insert(0, ketuaRegu);
      }

      // Update the labels for regular members
      int anggotaCount = 1;
      for (int i = 0; i < _members.length; i++) {
        if (_members[i]['jenisAnggota'] != 'Ketua Rombongan') {
          _members[i]['jenisAnggota'] = 'Anggota $anggotaCount';
          anggotaCount++;
        }
      }
    });
  }

  Widget _buildMemberForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tambah Anggota',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Ketua Rombongan'),
                value: 'Ketua Rombongan',
                groupValue: _selectedJenisAnggota,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisAnggota = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(_getNextMemberLabel()), // Use the dynamic label
                value: _getNextMemberLabel(), // Use the dynamic label
                groupValue: _selectedJenisAnggota,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisAnggota = value!;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('WNI'),
                value: 'WNI',
                groupValue: _selectedKewarganegaraan,
                onChanged: (value) {
                  setState(() {
                    _selectedKewarganegaraan = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('WNA'),
                value: 'WNA',
                groupValue: _selectedKewarganegaraan,
                onChanged: (value) {
                  setState(() {
                    _selectedKewarganegaraan = value!;
                  });
                },
              ),
            ),
          ],
        ),
        TextField(
          controller: _namaAnggotaController,
          decoration: InputDecoration(
            labelText: 'Nama Anggota',
            hintText: 'Contoh, John Doe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _noIdentitasController,
          decoration: InputDecoration(
            labelText: 'Nomor Identitas',
            hintText: 'KTP, SIM, Kartu Pelajar, Passport',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _noTeleponController,
          decoration: InputDecoration(
            labelText: 'Nomer Telepon',
            prefixText: '+62 ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 8),
        Text(
          '*Nomor harus terhubung dengan WA',
          style: TextStyle(color: Colors.blue[900]),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Contoh, JohnDoe@gmail.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Laki - Laki'),
                value: 'Laki - Laki',
                groupValue: _selectedJenisKelamin,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisKelamin = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Perempuan'),
                value: 'Perempuan',
                groupValue: _selectedJenisKelamin,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisKelamin = value!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ..._buildRiwayatPenyakitForm(),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addMember,
          child: Text(_isEditing ? 'Perbarui Anggota' : 'Tambahkan Anggota'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRiwayatPenyakitForm() {
    return [
      for (int i = 0; i < _riwayatPenyakitControllers.length; i++)
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _riwayatPenyakitControllers[i],
                decoration: InputDecoration(
                  labelText: 'Riwayat Penyakit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                _removeRiwayatPenyakit(i);
              },
              tooltip: 'Hapus Riwayat Penyakit',
            ),
          ],
        ),
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              setState(() {
                _riwayatPenyakitControllers.add(TextEditingController());
              });
            },
            tooltip: 'Tambahkan Riwayat Penyakit Baru',
          ),
          SizedBox(width: 8),
          Text(
            'Tambah Riwayat Penyakit',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ];
  }

  Widget _buildMemberCard(int index) {
    final member = _members[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member['jenisAnggota'] == 'Ketua Rombongan'
                  ? 'Ketua Rombongan'
                  : 'Anggota ${_members.where((member) => member['jenisAnggota'] != 'Ketua Rombongan').toList().indexOf(member) + 1}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMemberDetailRow('Nama:', member['namaAnggota']),
            _buildMemberDetailRow('No. Identitas:', member['noIdentitas']),
            _buildMemberDetailRow('No. Telepon:', member['noTelepon']),
            _buildMemberDetailRow('Email:', member['email']),
            _buildMemberDetailRow('Jenis Kelamin:', member['jenisKelamin']),
            _buildMemberDetailRow(
                'Kewarganegaraan:', member['kewarganegaraan']),
            _buildMemberDetailRow('Jenis Anggota:', member['jenisAnggota']),
            if (member['riwayatPenyakit'].isNotEmpty)
              for (var penyakit in member['riwayatPenyakit'])
                _buildMemberDetailRow('Riwayat Penyakit:', penyakit),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editMember(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _removeMember(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _navigateToVerifikasiPesananPage() async {
    final dataPesanan = widget.dataPesanan;
    dataPesanan['members'] = _members;

    await firestoreService.addGroupDetails({
      'namaGunung': dataPesanan['namaGunung'],
      'tanggalKeberangkatan': dataPesanan['tanggalKeberangkatan'],
      'jumlahAnggota': dataPesanan['jumlahAnggota'],
      'totalHarga': dataPesanan['totalHarga'],
      'members': _members,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifikasiPesananPage(dataPesanan: dataPesanan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi Anggota Rombongan'),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_isFormVisible)
                ElevatedButton(
                  onPressed: () => setState(() {
                    _isFormVisible = true;
                  }),
                  child: Text('Tambah Anggota'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
              else
                _buildMemberForm(),
              SizedBox(height: 20),
              if (!_isFormVisible)
                Column(
                  children: [
                    for (int i = 0; i < _members.length; i++)
                      _buildMemberCard(i),
                  ],
                ),
              if (_members.isNotEmpty && !_isFormVisible) ...[
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToVerifikasiPesananPage,
                    child: Text('Simpan Data Rombongan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
