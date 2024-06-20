import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> checkIfDataExists() async {
    final querySnapshot = await _db.collection('mountains').limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Stream<List<Mountain>> getMountains() {
    return _db.collection('mountains').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Mountain.fromFirestore(doc)).toList());
  }

  Future<void> addMountains(List<Mountain> mountains) async {
    final batch = _db.batch();
    for (Mountain mountain in mountains) {
      final docRef = _db.collection('mountains').doc(mountain.id);
      batch.set(docRef, mountain.toMap());
    }
    await batch.commit();
  }

  Future<void> addOrder(Map<String, dynamic> orderDetails) async {
    await _db.collection('orders').add(orderDetails);
  }

  Future<void> deleteOrder(String id) {
    return _db.collection('orders').doc(id).delete();
  }

  Future<void> addTransactionHistory(
      Map<String, dynamic> transactionDetails) async {
    transactionDetails['tanggalTransaksi'] = DateTime.now().toIso8601String();
    await _db.collection('transactionHistory').add(transactionDetails);
  }

  Future<void> addBookingDetails(Map<String, dynamic> bookingDetails) async {
    await _db.collection('bookings').add(bookingDetails);
  }

  Future<void> addGroupDetails(Map<String, dynamic> groupDetails) async {
    await _db.collection('groups').add(groupDetails);
  }

  Future<QuerySnapshot> getMountainByName(String name) {
    return _db.collection('mountains').where('name', isEqualTo: name).get();
  }

  Stream<DocumentSnapshot> getBookingDetails(String bookingId) {
    return _db.collection('bookings').doc(bookingId).snapshots();
  }

  Stream<List<Map<String, dynamic>>> getOrders() {
    return _db
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Stream<List<Map<String, dynamic>>> getTransactionHistory() {
    return _db
        .collection('transactionHistory')
        .orderBy('tanggalTransaksi', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Future<String> getImageUrlByMountainName(String name) async {
    var query =
        await _db.collection('mountains').where('name', isEqualTo: name).get();
    if (query.docs.isNotEmpty) {
      return query.docs.first['imageUrl'] as String;
    }
    return '';
  }

  WriteBatch batch() {
    return _db.batch();
  }

  DocumentReference getOrderDocRef(String id) {
    return _db.collection('orders').doc(id);
  }
}

class Mountain {
  final String id;
  final String name;
  final String location;
  final String province;
  final String imageUrl;
  final int workDayPriceWNI;
  final int holidayPriceWNI;
  final int workDayPriceWNA;
  final int holidayPriceWNA;
  final String description;

  Mountain({
    required this.id,
    required this.name,
    required this.location,
    required this.province,
    required this.imageUrl,
    required this.workDayPriceWNI,
    required this.holidayPriceWNI,
    required this.workDayPriceWNA,
    required this.holidayPriceWNA,
    required this.description,
  });

  factory Mountain.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Mountain(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      province: data['province'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      workDayPriceWNI: data['workDayPriceWNI'] ?? 0,
      holidayPriceWNI: data['holidayPriceWNI'] ?? 0,
      workDayPriceWNA: data['workDayPriceWNA'] ?? 0,
      holidayPriceWNA: data['holidayPriceWNA'] ?? 0,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'province': province,
      'imageUrl': imageUrl,
      'workDayPriceWNI': workDayPriceWNI,
      'holidayPriceWNI': holidayPriceWNI,
      'workDayPriceWNA': workDayPriceWNA,
      'holidayPriceWNA': holidayPriceWNA,
      'description': description,
    };
  }
}

final List<Mountain> mountains = [
  Mountain(
    id: 'gunung_merbabu',
    name: 'Gunung Merbabu',
    location: 'Kecamatan Selo, Kabupaten Boyolali, Jawa Tengah',
    province: 'Jawa Tengah',
    imageUrl: 'assets/gunung_merbabu.jpg',
    workDayPriceWNI: 20000,
    holidayPriceWNI: 25000,
    workDayPriceWNA: 30000,
    holidayPriceWNA: 35000,
    description:
        'Gunung Merbabu adalah gunung api yang terletak di Jawa Tengah dengan pemandangan yang indah.',
  ),
  Mountain(
    id: 'gunung_bromo',
    name: 'Gunung Bromo',
    location: 'Kecamatan Sukapura, Kabupaten Probolinggo, Jawa Timur',
    province: 'Jawa Timur',
    imageUrl: 'assets/gunung_bromo.jpg',
    workDayPriceWNI: 22000,
    holidayPriceWNI: 32000,
    workDayPriceWNA: 32000,
    holidayPriceWNA: 42000,
    description:
        'Gunung Bromo adalah gunung berapi aktif yang terkenal dengan keindahan matahari terbitnya.',
  ),
  Mountain(
    id: 'gunung_rinjani',
    name: 'Gunung Rinjani',
    location: 'Lombok, Nusa Tenggara Barat',
    province: 'Nusa Tenggara Barat',
    imageUrl: 'assets/gunung_rinjani.jpg',
    workDayPriceWNI: 25000,
    holidayPriceWNI: 30000,
    workDayPriceWNA: 35000,
    holidayPriceWNA: 40000,
    description:
        'Gunung Rinjani adalah gunung berapi yang terletak di Lombok dengan pemandangan yang memukau.',
  ),
  Mountain(
    id: 'gunung_semeru',
    name: 'Gunung Semeru',
    location: 'Kabupaten Malang, Jawa Timur',
    province: 'Jawa Timur',
    imageUrl: 'assets/gunung_semeru.jpg',
    workDayPriceWNI: 22000,
    holidayPriceWNI: 27000,
    workDayPriceWNA: 32000,
    holidayPriceWNA: 37000,
    description:
        'Gunung Semeru adalah gunung tertinggi di Pulau Jawa dengan pemandangan yang luar biasa.',
  ),
  Mountain(
    id: 'gunung_kerinci',
    name: 'Gunung Kerinci',
    location: 'Kabupaten Kerinci, Jambi',
    province: 'Jambi',
    imageUrl: 'assets/gunung_kerinci.png',
    workDayPriceWNI: 20000,
    holidayPriceWNI: 25000,
    workDayPriceWNA: 30000,
    holidayPriceWNA: 35000,
    description:
        'Gunung Kerinci adalah gunung berapi tertinggi di Indonesia dengan pemandangan yang menakjubkan.',
  ),
];
