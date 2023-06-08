import 'package:flutter/material.dart';
import 'package:chatp/view/home.dart';

class TabBarBottom extends StatefulWidget {
  const TabBarBottom({super.key});

  @override
  State<TabBarBottom> createState() => _TabBarExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _TabBarExampleState extends State<TabBarBottom>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      '分类',
      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Text(
      '购物车',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Text(
      '我的',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.beach_access_sharp),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5_sharp),
              label: '我的',
            ),
          ])

    );
  }
}
