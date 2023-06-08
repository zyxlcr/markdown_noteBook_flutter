import 'package:chatp/model/book/book.dart';
import 'package:chatp/vendor/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart' as flutter_text;
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<BookSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  // 声明变量
  List<dynamic> _dataList = [];
  Document document = Document();

  // 获取数据
  Future<void> _getData(String key) async {
    try {
      final response = await Dio()
          .get('https://cn.godamanga.com/?s=${key}&post_type=wp-manga');
      setState(() {
        document = parse(response.data);
        //print(document.outerHtml);
        RuleSearch r = RuleSearch(
            bookList: ".entry-card",
            bookUrl: "tag.a@href",
            coverUrl: "a>img",
            name: ".entry-title>a@text");
        print(getSearch(document, r).length);
        getSearch(document, r).forEach((element) {
          print(element.bookUrl);
        });
        // document.querySelectorAll(selector)

        //_dataList = response.data;
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
    //_dataList.add({"title": "书架", "url": "/found/book"});
  }

  // 构建列表项
  Widget _buildListItem(dynamic item) {
    return ListTile(
      title: flutter_text.Text(item['title']),
      //subtitle: Text(item['body']),
    );
  }

  // 构建列表视图
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(_dataList[index]);
      },
    );
  }

  // 构建界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search books',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            // TODO: 处理搜索逻辑
            _getData(_searchController.text);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: 处理搜索逻辑
              _getData(_searchController.text);
            },
          )
        ],
      ),
      body: _dataList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildListView(),
    );
  }
}
