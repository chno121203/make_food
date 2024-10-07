import 'package:flutter/material.dart';
import 'restaurant_detail_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  // To store the ratings for each menu item
  List<int> ratings = List.filled(9, 0); // Initialize 9 menu items with 0 rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูเเนะนำประจำวัน'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: Text(
                'เมนูแนะนำ ที่คุณอาจชอบ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(
                    context,
                    _getMenuName(index),
                    'assets/images/Food.jpg',
                    _getRestaurantPage(index),
                    index, // Pass the index to handle rating for each menu
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(
      BuildContext context, String name, String imagePath, Widget page, int index) {
    return GestureDetector(
      onTap: () {
        _navigateWithTransition(context, page);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        shadowColor: const Color.fromARGB(255, 196, 196, 196).withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 255, 255, 255),
                    const Color.fromARGB(255, 255, 255, 255),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildStarRating(index), // Display star rating
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the star rating system
  Widget _buildStarRating(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (starIndex) {
        return IconButton(
          onPressed: () {
            setState(() {
              ratings[index] = starIndex + 1; // Set the rating
            });
          },
          icon: FaIcon(
            ratings[index] > starIndex ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
            color: ratings[index] > starIndex ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); 
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  String _getMenuName(int index) {
    final menuNames = [
      'ข้าวหน้าสลัดเนื้อกับผักดองสามรส',
      'ผัดไทยกุ้งสด',
      'ต้มยำกุ้ง',
      'แกงเขียวหวานไก่',
      'ข้าวผัดกระเพราหมูสับ',
      'ส้มตำไทย',
      'ขนมจีนน้ำยา',
      'แกงส้มชะอมกุ้ง',
      'ต้มข่าไก่',
    ];
    return menuNames[index];
  }

  Widget _getRestaurantPage(int index) {
    final pages = [
      const RestaurantDetailPage(),
    ];
    return index < pages.length
        ? pages[index]
        : const Center(child: Text('No page available'));
  }
}
