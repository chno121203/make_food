import 'package:flutter/material.dart';
import 'restaurant_detail_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  // Custom orange theme colors
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFB74D);
  static const Color darkOrange = Color(0xFFF57C00);

  List<Map<String, dynamic>> menuItems = List.generate(9, (index) => {
        'name': _getMenuName(index),
        'userRating': 0,
        'avgRating': (index + 3) % 5 + 1,
        'imagePath': 'assets/images/Food.jpg',
        'emoji': _getEmoji(index), // Add emoji for each item
        'page': _getRestaurantPage(index),
      });

  @override
  Widget build(BuildContext context) {
    menuItems.sort((a, b) => b['avgRating'].compareTo(a['avgRating']));

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('เมนูเเนะนำยอดนิยม '),
            Text('🏆', style: TextStyle(fontSize: 24)),
          ],
        ),
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightOrange.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Row(
                  children: [
                    Text(
                      'เมนูแนะนำ ที่คุณอาจชอบ ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: darkOrange,
                      ),
                    ),
                    Text('👨‍🍳', style: TextStyle(fontSize: 24)),
                  ],
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
                      menuItems[index]['emoji'],
                      menuItems[index]['page'],
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, String name, String imagePath, String emoji, Widget page, int index) {
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
        shadowColor: darkOrange.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(
                  top: BorderSide(color: lightOrange.withOpacity(0.5), width: 1),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkOrange,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildStarRating(index),
                  const SizedBox(height: 4),
                  _buildAverageRating(index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (starIndex) {
        return IconButton(
          onPressed: () {
            setState(() {
              menuItems[index]['userRating'] = starIndex + 1;
            });
          },
          icon: FaIcon(
            menuItems[index]['userRating'] > starIndex
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            color: menuItems[index]['userRating'] > starIndex ? primaryOrange : Colors.grey.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  Widget _buildAverageRating(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (starIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FaIcon(
            menuItems[index]['avgRating'] > starIndex
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            color: menuItems[index]['avgRating'] > starIndex ? primaryOrange : Colors.grey.withOpacity(0.5),
            size: 16,
          ),
        );
      }),
    );
  }

  static String _getEmoji(int index) {
    final emojis = ['🥩', '🍜', '🦐', '🍛', '🥘', '🥗', '🍝', '🍲', '🍗'];
    return emojis[index];
  }

  // Existing methods remain the same
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
}