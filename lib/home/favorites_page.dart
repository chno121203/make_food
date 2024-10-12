import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> favoriteMenus;

  const FavoritesPage({Key? key, required this.favoriteMenus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    );
  }
}
