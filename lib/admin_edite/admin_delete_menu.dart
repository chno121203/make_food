import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/admin_edite/admin_edit_menu.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการเมนูอาหาร'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('menus').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('ไม่มีข้อมูลเมนู'));
            }

            final menuList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menu = menuList[index].data() as Map<String, dynamic>;
                final docId = menuList[index].id; // Document ID

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(menu['menuName'] ?? 'ไม่มีชื่อเมนู'),
                    subtitle: Text(
                        'มื้อ: ${menu['meal'] ?? 'ไม่ระบุ'}\nสูตร: ${menu['recipe'] ?? 'ไม่มีสูตร'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.edit,
                              color: Colors.blue),
                          onPressed: () {
                            _editMenu(docId, menu); // Pass document ID and data
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.trashAlt,
                              color: Colors.red),
                          onPressed: () {
                            _deleteMenu(docId); // Pass document ID to delete
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteMenu(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('menus').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ลบเมนูสำเร็จ'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ลบเมนูไม่สำเร็จ: $e'),
        ),
      );
    }
  }

  void _editMenu(String docId, Map<String, dynamic> menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditMenu(
          menuId: docId, // Corrected parameter name
        ),
      ),
    );
  }
}
