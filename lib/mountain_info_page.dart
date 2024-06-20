import 'package:flutter/material.dart';

class MountainInfoPage extends StatelessWidget {
  final List<Article> volcanoArticles = [
    Article(
      title: 'Informasi Gunung Berapi di Indonesia',
      category: 'Volcano',
      imageUrl:
          'assets/artikel/artikel_gunungapi.jpg', // Add appropriate image path
      content: '''
Indonesia memiliki banyak gunung berapi aktif yang tersebar di berbagai pulau. Gunung berapi di Indonesia dikenal sering meletus dan mempengaruhi kehidupan masyarakat sekitarnya. 

Beberapa gunung berapi terkenal di Indonesia antara lain:
1. Gunung Merapi: Terletak di perbatasan Jawa Tengah dan Yogyakarta, Gunung Merapi adalah salah satu gunung berapi paling aktif di dunia. Letusan terbarunya pada tahun 2010 menyebabkan ribuan orang mengungsi.
2. Gunung Sinabung: Berada di Sumatera Utara, Gunung Sinabung mulai aktif kembali sejak 2010 setelah tidur selama ratusan tahun. Letusan yang terjadi terus-menerus mengakibatkan kerugian besar bagi penduduk setempat.
3. Gunung Bromo: Terkenal dengan pemandangannya yang indah, Gunung Bromo yang berada di Jawa Timur merupakan destinasi wisata populer. Namun, gunung ini juga sering menunjukkan aktivitas vulkanik.

Gunung-gunung berapi ini memiliki dampak signifikan terhadap lingkungan dan kehidupan manusia di sekitarnya. Penting untuk selalu waspada dan mengikuti arahan dari pihak berwenang terkait aktivitas gunung berapi.
      ''',
    ),
    Article(
      title: 'Letusan Gunung Merapi: Apa yang Harus Dilakukan?',
      category: 'Volcano',
      imageUrl:
          'assets/artikel/artikel_meletus.jpg', // Add appropriate image path
      content: '''
Saat terjadi letusan Gunung Merapi, penting untuk mengikuti panduan evakuasi dari pihak berwenang. Berikut adalah beberapa langkah yang harus dilakukan:

1. Tetap Tenang: Jangan panik. Panik dapat menyebabkan tindakan yang tidak rasional.
2. Ikuti Informasi Terbaru: Pastikan Anda selalu memantau informasi terbaru dari BPBD (Badan Penanggulangan Bencana Daerah) melalui radio, televisi, atau media sosial.
3. Siapkan Barang-Barang Penting: Siapkan dokumen penting, makanan, air minum, pakaian, obat-obatan, dan barang berharga lainnya.
4. Evakuasi ke Tempat Aman: Jika sudah ada instruksi untuk evakuasi, segera bergerak ke tempat yang telah ditentukan seperti posko evakuasi.
5. Lindungi Diri dari Abu Vulkanik: Gunakan masker atau kain basah untuk menutupi hidung dan mulut. Jika perlu, gunakan kacamata untuk melindungi mata.
6. Jauhi Area Bahaya: Hindari daerah aliran lava, sungai yang bisa membawa lahar, dan area yang terkena dampak abu vulkanik berat.

Keselamatan adalah prioritas utama. Jangan kembali ke rumah atau area yang berbahaya sampai pihak berwenang menyatakan aman.
      ''',
    ),
  ];

  final List<Article> mountaineeringArticles = [
    Article(
      title: 'Ikuti 7 Tips Hiking Aman saat Musim Kemarau di Gunung',
      category: 'Mountaineering',
      imageUrl:
          'assets/artikel/artikel_gunungkemarau.jpg', // Add appropriate image path
      content: '''
Hiking di musim kemarau memerlukan persiapan khusus untuk memastikan keselamatan dan kenyamanan. Berikut adalah 7 tips hiking aman saat musim kemarau:

1. Bawa Cukup Air: Pastikan membawa cukup air untuk mencegah dehidrasi. Pertimbangkan untuk membawa lebih dari yang biasanya Anda butuhkan.
2. Gunakan Pakaian yang Sesuai: Kenakan pakaian ringan, berwarna terang, dan menyerap keringat. Topi dan kacamata hitam juga dapat melindungi Anda dari sinar matahari.
3. Gunakan Sunscreen: Oleskan sunscreen dengan SPF tinggi untuk melindungi kulit dari paparan sinar UV yang berbahaya.
4. Pilih Waktu yang Tepat: Mulailah pendakian lebih awal di pagi hari atau di sore hari untuk menghindari panas terik siang hari.
5. Bawa Makanan Ringan: Bawa makanan ringan yang tinggi energi seperti kacang-kacangan, buah kering, dan energy bars.
6. Istirahat Secara Berkala: Ambil istirahat yang cukup untuk menghindari kelelahan. Cari tempat yang teduh untuk beristirahat.
7. Kenali Tanda-Tanda Heat Exhaustion: Pahami gejala-gejala heat exhaustion seperti pusing, mual, sakit kepala, dan keringat berlebihan. Jika mengalami gejala ini, segera beristirahat di tempat yang teduh dan minum air.

Dengan persiapan yang tepat, hiking di musim kemarau bisa menjadi pengalaman yang menyenangkan dan aman.
      ''',
    ),
    Article(
      title: 'Simak Panduan Esensial Pos Ijin Pendakian Arjuno Welirang',
      category: 'Mountaineering',
      imageUrl:
          'assets/artikel/artikel_posarjuno.png', // Add appropriate image path
      content: '''
Pendakian Gunung Arjuno Welirang memerlukan izin dari pos pendakian. Berikut adalah panduan esensial untuk mendapatkan izin pendakian:

1. Persiapkan Dokumen yang Diperlukan: Bawa identitas diri seperti KTP atau SIM, dan pastikan Anda memiliki surat izin pendakian yang bisa diperoleh dari pos pendakian setempat.
2. Daftar di Pos Pendakian: Daftarkan diri dan rombongan Anda di pos pendakian resmi. Pos pendakian utama untuk Gunung Arjuno Welirang biasanya berada di Tretes atau Lawang.
3. Ikuti Prosedur yang Ditentukan: Pihak pos pendakian akan memberikan arahan mengenai rute pendakian, titik air, dan area berbahaya. Dengarkan dan ikuti instruksi mereka dengan seksama.
4. Bayar Biaya Pendakian: Biaya pendakian biasanya digunakan untuk pemeliharaan jalur dan fasilitas pendakian. Pastikan untuk membawa uang tunai yang cukup.
5. Cek Perlengkapan: Pastikan semua perlengkapan pendakian Anda lengkap dan dalam kondisi baik. Perlengkapan wajib meliputi tenda, sleeping bag, pakaian hangat, sepatu gunung, peta, kompas, dan alat komunikasi.
6. Patuhi Aturan dan Etika Pendakian: Jangan merusak lingkungan, buang sampah pada tempatnya, dan patuhi semua aturan yang telah ditetapkan.

Pendakian Gunung Arjuno Welirang menawarkan pemandangan yang indah dan pengalaman mendaki yang menantang. Dengan mematuhi prosedur dan aturan, pendakian Anda akan lebih aman dan menyenangkan.
      ''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tips dan Artikel',
            style: TextStyle(color: Colors.white), // Change text color to white
          ),
          backgroundColor: Color(0xFF2E7D32),
          iconTheme:
              IconThemeData(color: Colors.white), // Change arrow color to white
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xB3000000),
            tabs: [
              Tab(text: 'Volcano'),
              Tab(text: 'Mountaineering'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ArticleList(articles: volcanoArticles),
            ArticleList(articles: mountaineeringArticles),
          ],
        ),
      ),
    );
  }
}

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  ArticleList({required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ArticleDetailPage(article: articles[index]),
              ),
            );
          },
          child: ArticleCard(article: articles[index]),
        );
      },
    );
  }
}

class Article {
  final String title;
  final String category;
  final String imageUrl;
  final String content;

  Article(
      {required this.title,
      required this.category,
      required this.imageUrl,
      required this.content});
}

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(article.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              article.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              article.category,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  ArticleDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          style: TextStyle(color: Colors.white), // Change text color to white
        ),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme:
            IconThemeData(color: Colors.white), // Change arrow color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(article.imageUrl),
              SizedBox(height: 16.0),
              Text(
                article.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                article.content,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
