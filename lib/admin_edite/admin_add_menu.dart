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
  String _ingredientsCategory =
      'เมนูเนื้อสัตว์'; // ค่าเริ่มต้นของหมวดหมู่วัตถุดิบหลัก
  String _ingredient = ''; // วัตถุดิบหลัก
  String _recipe = '';
  String _meal = 'morningmeal'; // Default value for meal
  String _youtubeLink = '';
  File? _imageFile; // ตัวแปรสำหรับเก็บไฟล์ภาพ

  final ImagePicker _picker = ImagePicker(); // สร้างตัวเลือก ImagePicker

  // URL ของภาพเริ่มต้น
  final String _defaultImageUrl =
      'https://images.ctfassets.net/kugm9fp9ib18/3aHPaEUU9HKYSVj1CTng58/d6750b97344c1dc31bdd09312d74ea5b/menu-default-image_220606_web.png';

  // Map สำหรับการแมประหว่างภาษาไทยและภาษาอังกฤษสำหรับหมวดหมู่วัตถุดิบหลัก
  final Map<String, String> _ingredientsCategoryMap = {
    'เมนูเนื้อสัตว์': 'meat',
    'เมนูอาหารทะเล': 'seafood',
    'เมนูจากผัก': 'vegetable',
    'เมนูไข่': 'egg',
  };

  // Map สำหรับการแมปวัตถุดิบหลักจากภาษาไทยเป็นภาษาอังกฤษ
  final Map<String, String> _ingredientMap = {
    'เนื้อวัว': 'beef',
    'เนื้อไก่': 'chicken',
    'เนื้อแพะ': 'goat',
    'เนื้อแกะ': 'lamb',
    'กุ้ง': 'shrimp',
    'หอย': 'shellfish',
    'ปู': 'crab',
    'ปลา': 'fish',
    'หมึก': 'squid',
    'ผักเขียว': 'green vegetables',
    'ผักดอก': 'flower vegetables',
    'ไข่ไก่': 'chicken egg',
    'ไข่เป็ด': 'duck egg',
    'ไข่เยี่ยวม้า': 'century egg',
  };

  // รายการหมวดหมู่วัตถุดิบหลัก
  final Map<String, List<String>> _ingredientOptions = {
    'เมนูเนื้อสัตว์': ['เนื้อวัว', 'เนื้อไก่', 'เนื้อแพะ', 'เนื้อแกะ'],
    'เมนูอาหารทะเล': ['กุ้ง', 'หอย', 'ปู', 'ปลา', 'หมึก'],
    'เมนูจากผัก': ['ผักเขียว', 'ผักดอก'],
    'เมนูไข่': ['ไข่ไก่', 'ไข่เป็ด', 'ไข่เยี่ยวม้า'],
  };

  // ฟังก์ชันในการอัพโหลดไฟล์ภาพ
  Future<String?> _uploadImage(File image) async {
    try {
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
      final menuId = 'menuID${DateTime.now().millisecondsSinceEpoch}';

      // แปลงค่า ingredientsCategory และ ingredient เป็นภาษาอังกฤษ
      String categoryInEnglish =
          _ingredientsCategoryMap[_ingredientsCategory] ?? _ingredientsCategory;
      String ingredientInEnglish = _ingredientMap[_ingredient] ?? _ingredient;

      await FirebaseFirestore.instance.collection('menus').doc(menuId).set({
        'menuName': _menuName,
        'ingredientsCategory': categoryInEnglish, // บันทึกเป็นภาษาอังกฤษ
        'ingredient': ingredientInEnglish, // บันทึกเป็นภาษาอังกฤษ
        'recipe': _recipe,
        'meal': _meal,
        'youtubeLink': _youtubeLink,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')),
      );

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
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
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
                // Dropdown สำหรับหมวดหมู่วัตถุดิบหลัก
                DropdownButtonFormField<String>(
                  value: _ingredientsCategory,
                  decoration: const InputDecoration(
                    labelText: 'หมวดหมู่วัตถุดิบหลัก',
                    border: OutlineInputBorder(),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: Colors.black,
                  ),
                  items: _ingredientOptions.keys.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _ingredientsCategory = value!;
                      _ingredient = ''; // รีเซ็ตวัตถุดิบเมื่อเลือกหมวดหมู่ใหม่
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Dropdown สำหรับวัตถุดิบหลัก
                DropdownButtonFormField<String>(
                  value: _ingredient.isEmpty
                      ? null
                      : _ingredient, // ตั้งค่าเป็น null ถ้าไม่มีการเลือกวัตถุดิบ
                  decoration: const InputDecoration(
                    labelText: 'วัตถุดิบหลัก',
                    border: OutlineInputBorder(),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: Colors.black,
                  ),
                  items: (_ingredientOptions[_ingredientsCategory] ?? [])
                      .map((String ingredient) {
                    return DropdownMenuItem(
                      value: ingredient,
                      child: Text(ingredient),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _ingredient = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวัตถุดิบหลัก';
                    }
                    return null;
                  },
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
                    setState(() {
                      _meal = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเมนู',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _menuName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อเมนู';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'สูตรอาหาร',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _recipe = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกสูตรอาหาร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ลิงก์ YouTube (ถ้ามี)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _youtubeLink = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String imageUrl = _defaultImageUrl;

                      if (_imageFile != null) {
                        final uploadedUrl = await _uploadImage(_imageFile!);
                        if (uploadedUrl != null) {
                          imageUrl = uploadedUrl;
                        }
                      }

                      _saveMenuData(imageUrl); // บันทึกข้อมูลเมนู
                    }
                  },
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันเลือกภาพจากแกลเลอรีหรือกล้อง
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
}
