import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class FoundScreen extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<FoundScreen> {
  // 声明变量
  List<dynamic> _dataList = [];

  // 获取数据
  Future<void> _getData() async {
    try {
      final response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      setState(() {
        _dataList = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  // 初始化
  @override
  void initState() {
    super.initState();
    //_getData();
    _dataList.add({"title": "书架", "url": "/book"});
    _dataList.add({"title": "笔记", "url": "/note"});
    _dataList.add({"title": "test", "url": "/test"});
  }

  // 构建列表项
  Widget _buildListItem(dynamic item) {
    return ListTile(
      title: Text(item['title']),
      //subtitle: Text(item['body']),
    );
  }

  // 构建列表视图
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print("Clicked on item $index");
            if (index == 0) {
              context.go("/book");
            } else if (index == 1) {
              context.go("/note");
            } else if (index == 2) {
              context.go("/test");
            }

            ///:$index
          },
          child: _buildListItem(_dataList[index]),
        );
      },
    );
  }

  // 构建界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Page'),
      ),
      body: _dataList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildListView(),
    );
  }
}
