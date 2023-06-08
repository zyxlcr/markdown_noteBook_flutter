import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: 处理搜索逻辑
              context.go('/book/search');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // 假设有10本书
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text('Book ${index + 1}'),
              subtitle: Text('Author ${index + 1}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // TODO: 处理点击事件
              },
            ),
          );
        },
      ),
    );
  }
}
