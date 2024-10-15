import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makefood/menu/restaurants_page.dart';
import 'package:makefood/menu/meal_page.dart';
import 'package:makefood/register/login_page.dart';
import 'package:makefood/home/favorites_page.dart'; // นำเข้า FavoritesPage
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอพแนะนำอาหาร 🍽️',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<String> tips = [
    '🥗 กินผักและผลไม้ให้หลากหลายเพื่อรับวิตามินและแร่ธาตุ',
    '💧 ดื่มน้ำให้เพียงพอทุกวันเพื่อให้ร่างกายทำงานได้อย่างมีประสิทธิภาพ',
    '🌾 เลือกกินธัญพืชเต็มเมล็ดแทนข้าวขาวเพื่อเพิ่มไฟเบอร์ในอาหาร',
    '🧂 ลดการบริโภคน้ำตาลและเกลือเพื่อลดความเสี่ยงต่อโรคเรื้อรัง',
    '🍲 การกินอาหารหลากหลายทำให้ร่างกายได้รับสารอาหารครบถ้วนและสมดุล',
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'เมนูแนะนำตามช่วงเวลา',
      'page': RecipesPage(),
      'icon': '🕒',
      'color': Colors.blue,
    },
    {
      'name': 'เมนูที่คุณชอบ',
      'page': null,
      'icon': '❤️',
      'color': Colors.red,
    },
  ];

  List<String> favoriteMenus = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadFavoriteMenus(); // โหลดเมนูที่ชอบเมื่อเริ่มต้น
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteMenus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMenus = prefs.getStringList('favoriteMenus') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final tip = tips[random.nextInt(tips.length)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade300, Colors.orange.shade100],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'แนะนำอาหาร 🍽️',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  background: Image.asset(
                    'assets/images/Food.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Text('👋', style: TextStyle(fontSize: 24)),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'ยินดีต้อนรับสู่แอพแนะนำอาหาร 👨‍🍳👩‍🍳',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ...menuItems
                          .map((menuItem) => _buildMenuItem(context, menuItem))
                          .toList(),
                      SizedBox(height: 30),
                      _buildTipCard(tip),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> menuItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            if (menuItem['name'] == 'เมนูที่คุณชอบ') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            } else {
              // แสดงเมนูที่แนะนำ
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menuItem['page']),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: menuItem['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(menuItem['icon'], style: TextStyle(fontSize: 30)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    menuItem['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String tip) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ScaleTransition(
              scale: _animation,
              child: Text('💡', style: TextStyle(fontSize: 40)),
            ),
            SizedBox(height: 10),
            Text(
              'เคล็ดลับสุขภาพ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              tip,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ 🚪'),
          content: Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }
}
