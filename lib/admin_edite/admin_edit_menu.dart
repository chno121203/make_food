import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminEditMenu extends StatefulWidget {
  final String menuId;

  const AdminEditMenu({required this.menuId, Key? key}) : super(key: key);

  @override
  _AdminEditMenuState createState() => _AdminEditMenuState();
}

class _AdminEditMenuState extends State<AdminEditMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _menuName = '';
  String _ingredients = '';
  String _recipe = '';
  String _meal = 'morningmeal';
  String _youtubeLink = '';
  File? _imageFile;
  bool _isLoading = true;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    try {
      final menuDoc = await FirebaseFirestore.instance
          .collection('menus')
          .doc(widget.menuId)
          .get();

      if (menuDoc.exists) {
        final data = menuDoc.data()!;
        setState(() {
          _menuName = data['menuName'] ?? '';
          _ingredients = data['ingredients'] ?? '';
          _recipe = data['recipe'] ?? '';
          _meal = data['meal'] ?? 'morningmeal';
          _youtubeLink = data['youtubeLink'] ?? '';
          _imageUrl = data['imageUrl'] ?? null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading menu data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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

  Future<void> _updateMenuData(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('menus')
          .doc(widget.menuId)
          .update({
        'menuName': _menuName,
        'ingredients': _ingredients,
        'recipe': _recipe,
        'meal': _meal,
        'youtubeLink': _youtubeLink,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating menu data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขเมนูอาหาร'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _imageFile == null
                                ? _imageUrl != null
                                    ? Image.network(_imageUrl!,
                                        fit: BoxFit.cover)
                                    : const Text('อัปโหลดรูปภาพ',
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
                          DropdownMenuItem(
                              value: 'morningmeal', child: Text('เช้า')),
                          DropdownMenuItem(
                              value: 'lunchmeal', child: Text('กลางวัน')),
                          DropdownMenuItem(
                              value: 'dinnermeal', child: Text('เย็น')),
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
                        initialValue: _menuName,
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
                        initialValue: _ingredients,
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
                        initialValue: _recipe,
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
                        initialValue: _youtubeLink,
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
                              imageUrl = _imageUrl!;
                            }
                            await _updateMenuData(imageUrl);
                          }
                        },
                        child: const Text(
                          'บันทึกการแก้ไข',
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
}
