import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String restaurantName; 
  final String description; 
  final List<Map<String, String>> ingredients; 

  const RestaurantDetailPage({
    Key? key,
    required this.restaurantName,
    required this.description,
    required this.ingredients,
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดเมนู'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.heart),
            onPressed: () {
              // เพิ่มฟังก์ชันการบันทึกเมนูโปรดที่นี่
              _saveToFavorites(restaurantName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/Food.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      restaurantName, 
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: const Color(0xFFFFF3E0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ส่วนผสม',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800]),
                  ),
                  const SizedBox(height: 8),
                  ...ingredients.map((ingredient) {
                    return _buildIngredientRow(
                      ingredient['name'] ?? '',
                      ingredient['amount'] ?? '',
                      ingredient['unit'] ?? '',
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description, 
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'คำแนะนำ:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 247, 113, 3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  'ดูคลิปเพิ่มเติมได้ที่: https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientRow(String name, String amount, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Row(
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(width: 5),
              Text(unit, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  void _saveToFavorites(String restaurantName) {
    // ฟังก์ชันในการบันทึกเมนูโปรด (สามารถใช้งานร่วมกับฐานข้อมูลหรือสถานะภายใน)
    print('$restaurantName ถูกบันทึกเป็นโปรด');
  }
}
