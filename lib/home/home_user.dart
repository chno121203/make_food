import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makefood/menu/restaurants_page.dart';
import 'package:makefood/menu/meal_page.dart';
import 'package:makefood/register/login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math'; // สำหรับการสุ่ม

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ข้อดีของการกินอาหารครบ 5 หมู่
    final List<String> tips = [
      'กินผักและผลไม้ให้หลากหลายเพื่อรับวิตามินและแร่ธาตุ.',
      'ดื่มน้ำให้เพียงพอทุกวันเพื่อให้ร่างกายทำงานได้อย่างมีประสิทธิภาพ.',
      'เลือกกินธัญพืชเต็มเมล็ดแทนข้าวขาวเพื่อเพิ่มไฟเบอร์ในอาหาร.',
      'ลดการบริโภคน้ำตาลและเกลือเพื่อลดความเสี่ยงต่อโรคเรื้อรัง.',
      'การกินอาหารหลากหลายทำให้ร่างกายได้รับสารอาหารครบถ้วนและสมดุล.',
    ];

    // สุ่มเลือกข้อความ
    final random = Random();
    final tip = tips[random.nextInt(tips.length)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('แนะนำอาหาร'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'ยินดีต้อนรับสู่แอพแนะนำอาหาร',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/Food.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),
              _buildButton(context, 'เมนูแนะนำตามช่วงเวลา', RecipesPage()),
              const SizedBox(height: 15),
              _buildButton(context, 'เมนูเเนะนำประจำวัน', RestaurantsPage()),
              const SizedBox(height: 30), // เพิ่มช่องว่างระหว่างปุ่มและข้อความ
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tips: $tip',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
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
            ),
          ],
        );
      },
    );
  }
}
