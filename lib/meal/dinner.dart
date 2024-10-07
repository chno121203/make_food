import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/menu/restaurant_detail_page.dart'; // Import the RestaurantDetailPage

class DinnerPage extends StatefulWidget {
  const DinnerPage({super.key});

  @override
  _DinnerPageState createState() => _DinnerPageState();
}

class _DinnerPageState extends State<DinnerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _meals = [];
  bool _isLoading = true;
  bool _hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomMeals();
  }

  Future<void> _fetchRandomMeals() async {
    try {
      // Get all documents where meal == 'lunchmeal'
      final querySnapshot = await _firestore
          .collection('menus')
          .where('meal', isEqualTo: 'dinnermeal')
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _meals = [];
          _isLoading = false;
          _hasMoreItems = false;
        });
        return;
      }

      // Shuffle and take 5 items
      final allMeals = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      allMeals.shuffle(); // Shuffle the list
      final randomMeals = allMeals.take(5).toList();

      setState(() {
        _meals = randomMeals;
        _isLoading = false;
        _hasMoreItems = randomMeals.length < allMeals.length;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreItems = false;
      });
      print('Error fetching meals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'อาหารเย็น',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
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
              'รายการอาหารเย็นที่แนะนำ',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RestaurantDetailPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 61, 61, 61),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(meal['menuName'] ?? 'ไม่มีชื่อเมนู'),
                              subtitle: Text(
                                (meal['recipe'] as String).length > 20
                                    ? '${(meal['recipe'] as String).substring(0, 20)}...'
                                    : meal['recipe'] ?? 'ไม่มีสูตร',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            if (_hasMoreItems)
              ElevatedButton(
                onPressed: _fetchRandomMeals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'อื่นๆอีก',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
