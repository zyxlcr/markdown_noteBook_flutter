import 'package:chatp/widget/expansion_tile_plus.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  // Controller
  late ExpandedTileController _controller;

  void initState() {
    // initialize controller
    _controller = ExpandedTileController(isExpanded: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          //* Seperate usage of a tile.
          Column(children: [
        ExpandedTile(
          theme: const ExpandedTileThemeData(
            headerColor: Colors.green,
            headerRadius: 24.0,
            headerPadding: EdgeInsets.all(24.0),
            headerSplashColor: Colors.red,
            contentBackgroundColor: Colors.blue,
            contentPadding: EdgeInsets.all(24.0),
            contentRadius: 12.0,
          ),
          hiddenHead: true,
          controller: _controller,
          title: const Text("this is the title"),
          leading: IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                _controller.toggle();
              }),
          enabled: false,
          //isExpanded: true,
          content: Container(
            color: Colors.red,
            child: const Center(
              child: Text("This is the content!"),
            ),
          ),
          onTap: () {
            debugPrint("tapped!!");
          },
          onLongTap: () {
            debugPrint("long tapped!!");
          },
        ),
        Text("data"),
        ExpandedTileList.builder(
          itemCount: 3,
          maxOpened: 2,
          reverse: true,
          itemBuilder: (context, index, controller) {
            return ExpandedTile(
              theme: const ExpandedTileThemeData(
                headerColor: Colors.green,
                headerRadius: 24.0,
                headerPadding: EdgeInsets.all(24.0),
                headerSplashColor: Colors.red,
                //
                contentBackgroundColor: Colors.blue,
                contentPadding: EdgeInsets.all(24.0),
                contentRadius: 12.0,
              ),
              controller: controller,
              title: Text("this is the title $index"),
              content: Container(
                color: Colors.red,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                          "This is the content!ksdjfl kjsdflk sjdflksjdf lskjfd lsdkfj  ls kfjlsfkjsdlfkjsfldkjsdflkjsfdlksjdflskdjf lksdjflskfjlsfkjslfkjsldfkjslfkjsldfkjsflksjflskjflskfjlsfkjslfkjsflksjflskfjlsfkjslfkjslfkjslfkjslfkjsldfkjsdf"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        controller.collapse();
                      },
                      child: Text("close it!"),
                    )
                  ],
                ),
              ),
              onTap: () {
                debugPrint("tapped!!");
              },
              onLongTap: () {
                debugPrint("looooooooooong tapped!!");
              },
            );
          },
        ),
      ]),
      //* Starting V0.3.4 : ExpandedTileList.builder widget is available.
    );
  }
}
