import 'package:flutter/material.dart';

class TwoColumnLayout extends StatelessWidget {
  final List<Widget> _tabs = [
    Text('Tab 1'),
    Text('Tab 2'),
    Text('Tab 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two-Column Layout'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DefaultTabController(
              length: _tabs.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: TabBar(
                      tabs: _tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text('Tab 1')),
                        Center(child: Text('Tab 2')),
                        Center(child: Text('Tab 3')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: Text('This is a sample item'),
              ),
              itemCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
