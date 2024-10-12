import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/menu/restaurant_detail_page.dart'; // Import the RestaurantDetailPage

class LunchPage extends StatefulWidget {
  const LunchPage({Key? key}) : super(key: key);

  @override
  _LunchPageState createState() => _LunchPageState();
}

class _LunchPageState extends State<LunchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _meals = [];
  bool _isLoading = true;
  Map<String, bool> _favoriteMeals = {};
  String _selectedCategory = 'all';
  String? _selectedSubCategory;

  final List<Map<String, String>> _categories = [
    {'label': 'ทั้งหมด', 'value': 'all'},
    {'label': 'เมนูเนื้อสัตว์', 'value': 'meat'},
    {'label': 'เมนูอาหารทะเล', 'value': 'seafood'},
    {'label': 'เมนูจากผัก', 'value': 'vegetable'},
    {'label': 'เมนูไข่', 'value': 'egg'},
  ];

  final Map<String, List<Map<String, String>>> _subCategories = {
    'meat': [
      {'label': 'เนื้อวัว', 'value': 'beef'},
      {'label': 'เนื้อไก่', 'value': 'chicken'},
      {'label': 'เนื้อแพะ', 'value': 'goat'},
      {'label': 'เนื้อแกะ', 'value': 'lamb'},
    ],
    'seafood': [
      {'label': 'กุ้ง', 'value': 'shrimp'},
      {'label': 'หอย', 'value': 'shellfish'},
      {'label': 'ปู', 'value': 'crab'},
      {'label': 'ปลา', 'value': 'fish'},
      {'label': 'หมึก', 'value': 'squid'},
    ],
    'vegetable': [
      {'label': 'ผักใบเขียว', 'value': 'green_vegetable'},
      {'label': 'ผักดอก', 'value': 'flower_vegetable'},
    ],
    'egg': [
      {'label': 'ไข่ไก่', 'value': 'chicken_egg'},
      {'label': 'ไข่เป็ด', 'value': 'duck_egg'},
      {'label': 'ไข่เยี่ยวม้า', 'value': 'century_egg'},
    ],
  };

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _fetchAllBreakfastMeals();
  }

  Future<void> _fetchAllBreakfastMeals() async {
=======
    _fetchAllLunchMeals(); // Fetch all lunch meals on initialization
  }

  Future<void> _fetchAllLunchMeals() async {
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
    setState(() {
      _isLoading = true;
    });

    try {
<<<<<<< HEAD
      Query query =
          _firestore.collection('menus').where('meal', isEqualTo: 'lunchmeal');
=======
      Query query = _firestore.collection('menus').where('meal', isEqualTo: 'lunchmeal'); // Changed to 'lunchmeal'
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670

      if (_selectedCategory != 'all') {
        query = query.where('ingredient', isEqualTo: _selectedSubCategory);
      }

      if (_selectedSubCategory != null) {
        query =
            query.where('ingredientsCategory', isEqualTo: _selectedCategory);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _meals = [];
          _isLoading = false;
        });
        return;
      }

      final allMeals = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();

      for (var meal in allMeals) {
        final isFavorite = meal['favorites'] == 1;
        _favoriteMeals[meal['menuName']] = isFavorite;
      }

      setState(() {
        _meals = allMeals;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching meals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateFavoriteStatus(String menuName, bool isFavorite) async {
    try {
      print(
          'Updating favorite status for menuName: $menuName, isFavorite: $isFavorite');

      // ค้นหาเอกสารที่มี menuName ตรงกัน
      final querySnapshot = await _firestore
          .collection('menus')
          .where('menuName', isEqualTo: menuName)
          .limit(1) // จำกัดให้ค้นหาเอกสารเดียว
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // หากพบเอกสารที่ตรงกัน
        final documentId = querySnapshot.docs.first.id; // รับ ID ของเอกสาร
        print('Found document with ID: $documentId');

        await _firestore
            .collection('menus')
            .doc(documentId)
            .update({'favorites': isFavorite ? 1 : 0});

        print(
            'Updated favorites to ${isFavorite ? 1 : 0} for document ID: $documentId');
      } else {
        print('No document found for menuName: $menuName');
      }
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
<<<<<<< HEAD
          'อาหารเช้า',
=======
          'อาหารเที่ยง',
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/Food.jpg',
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
<<<<<<< HEAD
              'รายการอาหารเช้าที่แนะนำ',
=======
              'รายการอาหารเที่ยงที่แนะนำ',
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'เลือกหมวดหมู่: ',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
<<<<<<< HEAD
                        _selectedSubCategory =
                            null; // Reset sub-category when changing main category
                        _fetchAllBreakfastMeals(); // Fetch meals based on new category
=======
                        _selectedSubCategory = null; // Reset sub-category when changing main category
                        _fetchAllLunchMeals(); // Fetch meals based on new category
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
                      });
                    },
                    items:
                        _categories.map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category['value'],
                        child: Text(category['label']!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedCategory != 'all' &&
                _subCategories.containsKey(_selectedCategory))
              Row(
                children: [
                  const Text(
                    'เลือกวัตถุดิบย่อย: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedSubCategory,
                      hint: const Text('เลือกวัตถุดิบย่อย'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubCategory = newValue!;
<<<<<<< HEAD
                          _fetchAllBreakfastMeals(); // Fetch meals based on selected sub-category
=======
                          _fetchAllLunchMeals(); // Fetch meals based on selected sub-category
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
                        });
                      },
                      items: _subCategories[_selectedCategory]!
                          .map<DropdownMenuItem<String>>((subCategory) {
                        return DropdownMenuItem<String>(
                          value: subCategory['value'],
                          child: Text(subCategory['label']!),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailPage(
                                  restaurantName: meal['menuName'],
                                  description: meal['recipe'] ??
                                      'ไม่มีรายละเอียด', // ส่ง recipe เป็น description
                                  ingredients: [
                                    {
                                      'name': meal['ingredient'],
                                      'amount': '1',
                                      'unit': 'portion'
                                    },
                                  ],
                                ),
                              ),
                            );
                          },
<<<<<<< HEAD
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal['menuName'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        meal['description'] ??
                                            'ไม่มีรายละเอียด',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _favoriteMeals[meal['menuName']] == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _favoriteMeals[meal['menuName']] ==
                                              true
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Toggle favorite status
                                      setState(() {
                                        _favoriteMeals[meal['menuName']] =
                                            !_favoriteMeals[meal['menuName']]!;
                                        _updateFavoriteStatus(
                                          meal['menuName'],
                                          _favoriteMeals[meal['menuName']]!,
                                        );
                                      });
                                    },
                                  ),
                                ],
=======
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(meal['menuName'] ?? 'ไม่มีชื่อ'),
                              subtitle: Text(meal['description'] ?? 'ไม่มีรายละเอียด'),
                              trailing: IconButton(
                                icon: Icon(
                                  _favoriteMeals[meal['menuName']] == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _favoriteMeals[meal['menuName']] == true
                                      ? Colors.red
                                      : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _favoriteMeals[meal['menuName']] = !_favoriteMeals[meal['menuName']]!; // Toggle favorite status
                                  });
                                  _updateFavoriteStatus(meal['menuName'], _favoriteMeals[meal['menuName']]!); // Update favorite status in Firestore
                                },
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
