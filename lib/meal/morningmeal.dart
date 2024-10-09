import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/menu/restaurant_detail_page.dart'; // Import the RestaurantDetailPage

class MorningMealPage extends StatefulWidget {
  const MorningMealPage({super.key});

  @override
  _MorningMealPageState createState() => _MorningMealPageState();
}

class _MorningMealPageState extends State<MorningMealPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _meals = [];
  bool _isLoading = true;
  Map<String, bool> _favoriteMeals = {}; // Store favorite status of meals
  String _selectedCategory = 'all'; // Default category
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
    _fetchRandomMeals();
  }

  Future<void> _fetchRandomMeals() async {
    try {
      Query query = _firestore.collection('menus').where('meal', isEqualTo: 'morningmeal');

      if (_selectedCategory != 'all') {
        query = query.where('category', isEqualTo: _selectedCategory);
      }

      if (_selectedSubCategory != null) {
        query = query.where('subCategory', isEqualTo: _selectedSubCategory);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _meals = [];
          _isLoading = false;
        });
        return;
      }

      // Shuffle and take 5 random meals
      final allMeals = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      allMeals.shuffle();
      final randomMeals = allMeals.take(5).toList();

      // Initialize favorite status
      for (var meal in randomMeals) {
        _favoriteMeals[meal['menuName']] = false; // Default to not favorite
      }

      setState(() {
        _meals = randomMeals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching meals: $e');
    }
  }

  Future<void> _updateFavoriteStatus(String menuName, bool isFavorite) async {
    try {
      await _firestore.collection('favorites').doc(menuName).set({
        'isFavorite': isFavorite,
      });
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'อาหารเช้า',
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
              'รายการอาหารเช้าที่แนะนำ',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Dropdown for main category selection
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
                        _selectedSubCategory = null; // Reset sub-category when changing main category
                        _fetchRandomMeals(); // Fetch meals based on new category
                      });
                    },
                    items: _categories.map<DropdownMenuItem<String>>((category) {
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

            // Dropdown for sub-category selection with label
            if (_selectedCategory != 'all' && _subCategories.containsKey(_selectedCategory))
              Row(
                children: [
                  const Text(
                    'เลือกวัตถุดิบย่อย: ', 
                    style: TextStyle(fontSize: 16), // Text label
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedSubCategory,
                      hint: const Text('เลือกวัตถุดิบย่อย'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubCategory = newValue!;
                          _fetchRandomMeals(); // Fetch meals based on selected sub-category
                        });
                      },
                      items: _subCategories[_selectedCategory]!.map<DropdownMenuItem<String>>((subCategory) {
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
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    RestaurantDetailPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  final tween = Tween(begin: begin, end: end);
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: curve,
                                  );

                                  return SlideTransition(
                                    position: tween.animate(curvedAnimation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
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
                                  spreadRadius: 0.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: Text(
                                  '${index + 1}', // Show numbering for the meal
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(meal['menuName']),
                              trailing: IconButton(
                                icon: Icon(
                                  _favoriteMeals[meal['menuName']] == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _favoriteMeals[meal['menuName']] == true
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _favoriteMeals[meal['menuName']] =
                                        !_favoriteMeals[meal['menuName']]!;
                                  });
                                  _updateFavoriteStatus(meal['menuName'],
                                      _favoriteMeals[meal['menuName']]!);
                                },
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
