import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyListItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  const MyListItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}

final List<MyListItem> _items = [
  MyListItem(
    title: 'Title 1',
    subtitle: 'Subtitle 1',
    time: '10:00 AM',
    icon: Icons.ac_unit,
  ),
  MyListItem(
    title: 'Title 2',
    subtitle: 'Subtitle 2',
    time: '11:00 AM',
    icon: Icons.access_alarm,
  ),
  // add more items here as needed
];

class MyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _items[index];
        return GestureDetector(
            onTap: () {
              print("Clicked on item $index");
              context.go("/chat");

              ///:$index
            },
            child: ListTile(
                leading: Icon(item.icon),
                title: TextButton(
                    onPressed: () => context.go("/chat"),
                    child: Text(item.title)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.subtitle),
                  ],
                ),
                trailing: Column(
                  children: [
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 4.0),
                  ],
                )));
      },
    );
  }
}
