import 'package:flutter/material.dart';
import 'package:makefood/meal/morningmeal.dart';
import 'package:makefood/meal/lunch.dart';
import 'package:makefood/meal/dinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  Widget _buildMealButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[100],
        foregroundColor: Colors.orange[800],
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size.fromHeight(60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ).copyWith(
        elevation: MaterialStateProperty.resolveWith<double>((states) {
          if (states.contains(MaterialState.hovered)) {
            return 10;
          }
          return 5;
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.orange[200]!;
          }
          return Colors.orange[100]!;
        }),
      ),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
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
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.orange[800]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
  '🍎 กินอาหารให้ครบ 5 หมู่ เพื่อสุขภาพที่ดีและสมดุล',
  '🥗 เพิ่มผักและผลไม้ในทุกมื้อ เพื่อเสริมไฟเบอร์และวิตามินที่ร่างกายต้องการ',
  '💧 ดื่มน้ำให้เพียงพอ วันละ 8 แก้ว เพื่อช่วยให้ระบบต่างๆ ทำงานได้ดี',
  '🍬 ลดน้ำตาลและไขมันทรานส์ เพื่อสุขภาพที่ดี ลดความเสี่ยงจากโรคเรื้อรัง',
  '🍽️ แบ่งมื้อเล็กๆ ทานตลอดวัน ช่วยควบคุมน้ำหนักและเพิ่มพลังงานให้คงที่',
];


    final random = Random();
    final tip = tips[random.nextInt(tips.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text('แนะนำอาหารแต่ละมื้ออาหาร 🍽️', style: TextStyle(color: Colors.orange[800])),
        backgroundColor: Colors.orange[50],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.orange[800]),
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
            colors: [Colors.orange[50]!, Colors.orange[100]!],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
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
                _buildMealButton(context, 'ช่วงเช้า ☀️', const MorningMealPage()),
                const SizedBox(height: 20),
                _buildMealButton(context, 'ช่วงเที่ยง 🌞', const LunchPage()),
                const SizedBox(height: 20),
                _buildMealButton(context, 'ช่วงเย็น 🌙', const DinnerPage()),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Text(
                    'Tips : $tip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
