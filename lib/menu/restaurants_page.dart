import 'package:flutter/material.dart';
import 'restaurant_detail_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  // To store the ratings for each menu item, along with fictional average ratings
  List<Map<String, dynamic>> menuItems = List.generate(9, (index) => {
        'name': _getMenuName(index),
        'userRating': 0, // User's rating
        'avgRating': (index + 3) % 5 + 1, // Simulated average rating from other users
        'imagePath': 'assets/images/Food.jpg',
        'page': _getRestaurantPage(index),
      });

  @override
  Widget build(BuildContext context) {
    // Sort menuItems by average rating in descending order
    menuItems.sort((a, b) => b['avgRating'].compareTo(a['avgRating']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูเเนะนำยอดนิยม'),
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
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(
                    context,
                    menuItems[index]['name'],
                    menuItems[index]['imagePath'],
                    menuItems[index]['page'],
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, String name, String imagePath, Widget page, int index) {
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
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white],
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
                  const SizedBox(height: 4),
                  _buildAverageRating(index), // Display average rating
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the star rating system for user input
  Widget _buildStarRating(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (starIndex) {
        return IconButton(
          onPressed: () {
            setState(() {
              menuItems[index]['userRating'] = starIndex + 1; // Set user's rating
            });
          },
          icon: FaIcon(
            menuItems[index]['userRating'] > starIndex
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            color: menuItems[index]['userRating'] > starIndex ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  // Widget to display the average rating from other users
  Widget _buildAverageRating(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (starIndex) {
        return FaIcon(
          menuItems[index]['avgRating'] > starIndex
              ? FontAwesomeIcons.solidStar
              : FontAwesomeIcons.star,
          color: menuItems[index]['avgRating'] > starIndex ? Colors.amber : Colors.grey,
          size: 16, // Smaller star for average rating display
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

  static String _getMenuName(int index) {
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

  static Widget _getRestaurantPage(int index) {
    final pages = [
      const RestaurantDetailPage(),
    ];
    return index < pages.length
        ? pages[index]
        : const Center(child: Text('No page available'));
  }
}
