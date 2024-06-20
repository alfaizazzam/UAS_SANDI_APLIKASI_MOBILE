import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage>
    with SingleTickerProviderStateMixin {
  final List<String> categories = [
    "Semua",
    "Belum Siap",
    "Misc",
    "Bags",
    "Electronic",
    "Equipment",
    "Accessories",
    "Apparel"
  ];
  late TabController _tabController;
  final Map<String, List<String>> items = {
    "Misc": ["Handuk", "Pertolongan Pertama", "Toiletries"],
    "Apparel": [
      "Baselayer Insulated",
      "Baselayer Quick Dry",
      "Celana Hiking",
      "Celana Quick Dry",
      "Celana Waterproof",
      "Jaket Down",
      "Jaket Fleece",
      "Jaket Puffer",
      "Jaket Softshell",
      "Jaket Warmer"
    ],
    "Accessories": ["Kacamata", "Sarung Tangan", "Topi"],
    "Equipment": [
      "Botol Air",
      "Cooking Set 1P",
      "Cooking Set 2P",
      "Cooking Set 3P",
      "Cooking Set 4P",
      "Headlamp",
      "Kompor Camping",
      "Kompor Spiritus Camping",
      "Matras",
      "Peralatan Makan",
      "Perlengkapan Makan"
    ],
    "Electronic": ["Powerbank", "Baterai Cadangan", "Drone", "Kabel"],
    "Bags": ["Backpack", "Duffel Bag", "Daypack"],
  };

  Map<String, bool> allItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    items.forEach((category, itemList) {
      itemList.forEach((item) {
        allItems[item] = false;
      });
    });
  }

  void _addItem(String category, String newItem) {
    setState(() {
      items[category]?.add(newItem);
      allItems[newItem] = false;
    });
  }

  void _removeItem(String category, String item) {
    setState(() {
      items[category]?.remove(item);
      allItems.remove(item);
    });
  }

  void _showAddItemDialog(BuildContext context) {
    final TextEditingController _itemController = TextEditingController();
    String? selectedCategory = categories[2]; // Default to "Misc" category

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Nama Item'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  selectedCategory = newValue;
                },
                items: categories
                    .skip(2)
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (_itemController.text.isNotEmpty &&
                    selectedCategory != null) {
                  _addItem(selectedCategory!, _itemController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Tambahkan Item'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Checklist Perlengkapan',
            style: TextStyle(color: Colors.white), // Teks menjadi putih
          ),
          iconTheme: IconThemeData(color: Colors.white), // Ikon menjadi putih
          backgroundColor: Color(0xFF2E7D32),
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white, // Teks tab terpilih menjadi putih
            unselectedLabelColor: Color(0xFF000000),
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            if (category == "Semua") {
              return ChecklistCategory(
                category: category,
                items: allItems.keys.toList(),
                checkedItems: allItems,
                onChanged: (item, value) {
                  setState(() {
                    allItems[item] = value!;
                  });
                },
                onDelete: (item) {
                  _removeItem(category, item);
                },
              );
            } else if (category == "Belum Siap") {
              return ChecklistCategory(
                category: category,
                items: allItems.keys.where((item) => !allItems[item]!).toList(),
                checkedItems: allItems,
                onChanged: (item, value) {
                  setState(() {
                    allItems[item] = value!;
                  });
                },
                onDelete: (item) {
                  _removeItem(category, item);
                },
              );
            } else {
              return ChecklistCategory(
                category: category,
                items: items[category] ?? [],
                checkedItems: allItems,
                onChanged: (item, value) {
                  setState(() {
                    allItems[item] = value!;
                  });
                },
                onDelete: (item) {
                  _removeItem(category, item);
                },
              );
            }
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddItemDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFFF9800),
        ),
      ),
    );
  }
}

class ChecklistCategory extends StatelessWidget {
  final String category;
  final List<String> items;
  final Map<String, bool> checkedItems;
  final Function(String, bool?) onChanged;
  final Function(String) onDelete;

  ChecklistCategory(
      {required this.category,
      required this.items,
      required this.checkedItems,
      required this.onChanged,
      required this.onDelete});

  void _showDeleteConfirmationDialog(BuildContext context, String item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Item'),
          content: Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onDelete(item);
                Navigator.pop(context);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Warna kategori menjadi putih
          ),
        ),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: checkedItems[item],
                  onChanged: (bool? value) {
                    onChanged(item, value);
                  },
                ),
                title: Text(item),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, item);
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
