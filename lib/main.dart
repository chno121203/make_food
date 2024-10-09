import 'package:flutter/material.dart';
import 'package:makefood/register/sign_up.dart';
import 'firebase_options.dart'; // import ไฟล์สำหรับหน้า TipsPage
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("ailed to initialize Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แนะนำอาหาร',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Kanit', // ใช้ฟอนต์ Kanit หรือฟอนต์ไทยอื่นๆ ที่คุณชอบ
      ),
      home: const SignUpPage(),
    );
  }
}
