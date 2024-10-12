import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/menu/restaurant_detail_page.dart'; // Import the RestaurantDetailPage

class MorningMealPage extends StatefulWidget {
  const MorningMealPage({Key? key}) : super(key: key);

  @override
  _MorningMealPageState createState() => _MorningMealPageState();
}

class _MorningMealPageState extends State<MorningMealPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _meals = [];
  bool _isLoading = true;
  Map<String, int> _favoriteMeals = {}; // Change to int
  String _selectedCategory = 'all';
  String? _selectedSubCategory;

  // Categories and subcategories as defined in your code
  final List<Map<String, String>> _categories = [
    {'label': 'ทั้งหมด', 'value': 'all'},
    {'label': 'เมนูเนื้อสัตว์', 'value': 'meat'},
    {'label': 'เมนูอาหารทะเล', 'value': 'seafood'},
    {'label': 'เมนูจากผัก', 'value': 'vegetable'},
    {'label': 'เมนูไข่', 'value': 'egg'},
  ];

  final Map<String, List<Map<String, String>>> _subCategories = {
    // Define subcategories as in your code
    // ...
  };

  @override
  void initState() {
    super.initState();
    _fetchAllBreakfastMeals();
  }

  Future<void> _fetchAllBreakfastMeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Query query = _firestore.collection('menus').where('meal', isEqualTo: 'morningmeal');

      if (_selectedCategory != 'all') {
        query = query.where('category', isEqualTo: _selectedCategory);
      }

      if (_selectedSubCategory != null) {
        query = query.where('subcategory', isEqualTo: _selectedSubCategory);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _meals = [];
          _isLoading = false;
        });
        return;
      }

      final allMeals = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (var meal in allMeals) {
        // Initialize favorite status
        _favoriteMeals[meal['menuName']] = 0; // Initialize as 0 (not favorite)
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

  Future<void> _updateFavoriteStatus(String menuName, int status) async {
    print('Updated favorite status for $menuName to $status');
    
    try {
      // Assuming you have a user ID to associate the favorite with
      String userId = 'exampleUserId'; // Replace this with the actual user ID

      // Update Firestore
      await _firestore.collection('favorites').doc(userId).set({
        menuName: status,
      }, SetOptions(merge: true)); // Merge to update existing fields
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
                        _fetchAllBreakfastMeals(); // Fetch meals based on new category
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

            // Subcategory Dropdown
            if (_selectedCategory != 'all' && _subCategories.containsKey(_selectedCategory))
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
                          _fetchAllBreakfastMeals(); // Fetch meals based on selected sub-category
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

            // Loading Indicator or Meal List
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
                                    RestaurantDetailPage(
                                      restaurantName: meal['menuName'],
                                      description: meal['recipe'] ?? 'ไม่มีรายละเอียด',
                                      ingredients: List<Map<String, String>>.from(
                                        meal['ingredients']?.map<Map<String, String>>((ingredient) {
                                          return {
                                            'name': ingredient['name'],
                                            'amount': ingredient['amount'],
                                            'unit': ingredient['unit'],
                                          };
                                        }) ?? [],
                                      ),
                                    ),
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
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal['menuName'],
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(meal['recipe'] ?? 'ไม่มีรายละเอียด', maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _favoriteMeals[meal['menuName']] == 1
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: _favoriteMeals[meal['menuName']] == 1 ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // Toggle favorite status
                                        _favoriteMeals[meal['menuName']] = _favoriteMeals[meal['menuName']] == 1 ? 0 : 1;
                                        _updateFavoriteStatus(meal['menuName'], _favoriteMeals[meal['menuName']]!); // Update Firestore
                                      });
                                    },
                                  ),
                                ],
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
