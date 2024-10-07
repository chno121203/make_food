import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'ข้าวหน้าสลัดเนื้อกับผักดองสามรส',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Color(0xFFFFF3E0), // Light orange background
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
                  SizedBox(height: 10),
                  _buildIngredientRow('เนื้อวัวสไลด์', '230', 'กรัม'),
                  _buildIngredientRow('ผักดองคอนโซเมะ', '30', 'กรัม'),
                  _buildIngredientRow('เเตงกวาญี่ปุ่น', '1', 'ลูก/ผล'),
                  _buildIngredientRow('แครอทหั่นแว่น', '50', 'กรัม'),
                  _buildIngredientRow('มันฝรั่งต้มสุก', '50', 'กรัม'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'คำแนะนำ:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'ข้าวหน้าสลัดเนื้อกับผักดองสามรสเป็นอาหารที่มีรสชาติเข้มข้นและอร่อยสดชื่น เหมาะสำหรับมื้อเที่ยงหรือมื้อเย็น '
                'ที่ต้องการอาหารที่ทั้งอิ่มและมีประโยชน์ต่อสุขภาพ. '
                'สามารถทานคู่กับซอสสลัดหรือเพิ่มรสชาติด้วยน้ำจิ้มแจ่วได้ตามต้องการ.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ดูคลิปเพิ่มเติมได้ที่: https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
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
          Text(name, style: TextStyle(fontSize: 16, color: Colors.black87)),
          Row(
            children: [
              Text(amount,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(width: 5),
              Text(unit, style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
