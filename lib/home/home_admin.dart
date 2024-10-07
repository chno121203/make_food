import 'package:flutter/material.dart';
import 'package:makefood/register/login_page.dart';
import 'package:makefood/admin_edite/admin_add_menu.dart'; // นำเข้าคลาส AddPage
import 'package:makefood/admin_edite/admin_delete_menu.dart'; // นำเข้าคลาส AddPage
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // สีพื้นหลังของ AppBar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout), // ไอคอนล็อกเอาต์
            onPressed: () {
              _showLogoutDialog(context); // แสดงกล่องโต้ตอบยืนยันการล็อกเอาต์
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
              const Text(
                'Welcome to Adminnnnnnnnnnnnnnn Dashboarddddddd',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansThai', // ใช้ฟอนต์ที่กำหนดเอง
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/Food.jpg', // เปลี่ยนภาพตามต้องการ
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),
              _buildButton(context, 'เพิ่มเมนูอาหาร', const AddPage()),
              const SizedBox(height: 15),
              _buildButton(context, 'ลบเมนูอาหาร',
                  const DeletePage()), // เปลี่ยนหน้า Dummy Page เป็นหน้าที่ต้องการ
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างปุ่ม
  Widget _buildButton(BuildContext context, String text, Widget page) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 8.0), // เพิ่มระยะห่างระหว่างปุ่ม
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 255, 255, 255), // เปลี่ยนสีปุ่ม
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5, // เพิ่มเงาให้กับปุ่ม
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansThai', // ใช้ฟอนต์ที่กำหนดเอง
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันแสดงกล่องโต้ตอบยืนยันการล็อกเอาต์
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
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // หน้าตัวอย่างที่ใช้เป็นเป้าหมายการนำทาง
  Widget _dummyPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dummy Page'),
        backgroundColor: Colors.blue, // สีพื้นหลังของ AppBar
      ),
      body: const Center(
        child: Text(
          'This is a dummy page',
          style: TextStyle(
              fontSize: 20, fontFamily: 'NotoSansThai'), // ใช้ฟอนต์ที่กำหนดเอง
        ),
      ),
    );
  }
}
