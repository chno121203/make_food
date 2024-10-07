import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:makefood/home/home_admin.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _menuName = '';
  String _ingredients = '';
  String _recipe = '';
  String _meal = 'morningmeal'; // Default value for meal
  String _youtubeLink = '';
  File? _imageFile; // ตัวแปรสำหรับเก็บไฟล์ภาพ

  final ImagePicker _picker = ImagePicker(); // สร้างตัวเลือก ImagePicker

  // URL ของภาพเริ่มต้น
  final String _defaultImageUrl =
      'https://images.ctfassets.net/kugm9fp9ib18/3aHPaEUU9HKYSVj1CTng58/d6750b97344c1dc31bdd09312d74ea5b/menu-default-image_220606_web.png';

  // ฟังก์ชันในการอัพโหลดไฟล์ภาพ
  Future<String?> _uploadImage(File image) async {
    try {
      // สร้างชื่อไฟล์ภาพโดยใช้เวลาและ UID
      final fileName =
          'menu_food/menuID${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = storageRef.putFile(image);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // ฟังก์ชันในการบันทึกข้อมูลเมนูใน Firestore
  Future<void> _saveMenuData(String imageUrl) async {
    try {
      final menuId =
          'menuID${DateTime.now().millisecondsSinceEpoch}'; // สร้าง ID สำหรับเมนู
      await FirebaseFirestore.instance.collection('menus').doc(menuId).set({
        'menuName': _menuName,
        'ingredients': _ingredients,
        'recipe': _recipe,
        'meal': _meal,
        'youtubeLink': _youtubeLink,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')),
      );
      // นำทางไปยังหน้า AdminPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } catch (e) {
      print('Error saving menu data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเมนูอาหาร'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _pickImage(); // เรียกใช้ฟังก์ชันเลือกภาพ
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _imageFile == null
                          ? const Text('อัปโหลดรูปภาพ',
                              style: TextStyle(fontSize: 18))
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _meal,
                  decoration: const InputDecoration(
                    labelText: 'ช่วงเวลาอาหาร',
                    border: OutlineInputBorder(),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'morningmeal', child: Text('เช้า')),
                    DropdownMenuItem(
                        value: 'lunchmeal', child: Text('กลางวัน')),
                    DropdownMenuItem(value: 'dinnermeal', child: Text('เย็น')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _meal = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเมนู',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อเมนู';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _menuName = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'วัตถุดิบ',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกวัตถุดิบ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ingredients = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'สูตรอาหาร',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกสูตรอาหาร';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _recipe = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ลิ้งยูทูบวิธีการทำ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกลิ้งยูทูบ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _youtubeLink = value!;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String imageUrl;
                      if (_imageFile != null) {
                        final uploadedImageUrl =
                            await _uploadImage(_imageFile!);
                        if (uploadedImageUrl != null) {
                          imageUrl = uploadedImageUrl;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Error uploading image')),
                          );
                          return;
                        }
                      } else {
                        imageUrl = _defaultImageUrl;
                      }
                      await _saveMenuData(imageUrl);
                    }
                  },
                  child: const Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // เลือกภาพจากแกลเลอรี
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // เก็บไฟล์ภาพ
      });
    }
  }
}
