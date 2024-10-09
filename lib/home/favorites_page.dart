import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> favoriteMenus;

  const FavoritesPage({Key? key, required this.favoriteMenus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูที่คุณชอบ ❤️'),
      ),
      body: favoriteMenus.isEmpty
          ? Center(child: Text('ยังไม่มีเมนูที่คุณชอบ'))
          : ListView.builder(
              itemCount: favoriteMenus.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteMenus[index]),
                );
              },
            ),
    );
  }
}
