import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makefood/menu/restaurant_detail_page.dart';
=======
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('Favorite Menus'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menus')
            .where('favorites', isEqualTo: 1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final menus = snapshot.data!.docs;

          return ListView.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              var menu = menus[index];
              var menuName = menu['menuName'] ?? 'No Name';
              var ingredient = menu['ingredient'] ?? 'No Ingredient';
              var recipe = menu['recipe'] ?? 'No Recipe'; // ดึง recipe มาใช้

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailPage(
                        restaurantName: menuName,
                        description: recipe, // ส่ง recipe เป็น description
                        ingredients: [
                          {
                            'name': ingredient,
                            'amount': '1',
                            'unit': 'portion'
                          },
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ingredient: $ingredient',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
=======
        title: const Text(
          'เมนูโปรด',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: favoriteMenus.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีเมนูโปรด',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMenus.length,
              itemBuilder: (context, index) {
                final menuName = favoriteMenus[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      menuName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
>>>>>>> 1e7a5cc6e161f561b80cd4ac1ecfeff57843f670
    );
  }
}
