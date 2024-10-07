import 'package:flutter/material.dart';
import 'package:makefood/meal/morningmeal.dart';
import 'package:makefood/meal/lunch.dart';
import 'package:makefood/meal/dinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math'; // สำหรับการสุ่ม

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  Widget _buildMealButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size.fromHeight(60), // ปรับขนาดปุ่มให้ใหญ่ขึ้น
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          if (states.contains(WidgetState.hovered)) {
            return 10; // เพิ่มความนูนเมื่อ hover
          }
          return 5; // ความนูนปกติ
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return Color.fromARGB(
                255, 243, 243, 243); // เปลี่ยนเป็นสีเหลืองเมื่อ hover
          }
          return const Color.fromARGB(255, 255, 255, 255); // สีปกติ
        }),
      ),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // จากขวาไปซ้าย
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
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ข้อดีของการกินอาหารครบ 5 หมู่
    final List<String> tips = [
      'ช่วยให้ร่างกายได้รับสารอาหารที่จำเป็นครบถ้วนและสมดุล.',
      'ช่วยเสริมสร้างระบบภูมิคุ้มกันและป้องกันโรค.',
      'ทำให้การเจริญเติบโตและการพัฒนาร่างกายเป็นไปอย่างเหมาะสม.',
      'ช่วยให้การทำงานของระบบย่อยอาหารดีขึ้น.',
      'ช่วยรักษาน้ำหนักตัวให้อยู่ในระดับที่เหมาะสม.',
    ];

    // สุ่มเลือกข้อความ
    final random = Random();
    final tip = tips[random.nextInt(tips.length)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('แนะนำอาหารแต่ละหมู่'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false, // ซ่อนลูกศรย้อนกลับอัตโนมัติ
        leading: IconButton(
          icon: const FaIcon(
              FontAwesomeIcons.arrowLeft), // ไอคอนจาก Awesome Icons
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
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
              const SizedBox(height: 20), // เพิ่มช่องว่างระหว่างรูปภาพและปุ่ม
              _buildMealButton(context, 'ช่วงเช้า', const MorningMealPage()),
              const SizedBox(height: 20),
              _buildMealButton(context, 'ช่วงเที่ยง', const LunchPage()),
              const SizedBox(height: 20),
              _buildMealButton(context, 'ช่วงเย็น', const DinnerPage()),
              const SizedBox(height: 20), // เพิ่มช่องว่างระหว่างปุ่มและข้อความ
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tips : $tip',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
