import 'package:chatp/widget/tab_bottom.dart';
import 'package:flutter/material.dart';

class ThreeColumnLayout extends StatefulWidget {
  @override
  _ThreeColumnLayoutState createState() => _ThreeColumnLayoutState();
}

class _ThreeColumnLayoutState extends State<ThreeColumnLayout> with TickerProviderStateMixin{
  double leftWidth = 100.0; // 初始左侧栏宽度
  double middleWidth = 100.0; // 初始右侧栏宽度

  TextEditingController? titleController; // = TextEditingController();
  TextEditingController? contentController;

  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState

    titleController = TextEditingController();
    contentController = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Three Column Layout'),
      ),
      body: Row(children: [
        NestedTabBar("123"),
        // LayoutBuilder(
        //   builder: (context, constraints) {
        //     final maxWidth = constraints.maxWidth;
        //     final rightWidth = maxWidth - leftWidth - middleWidth;
        //
        //     return Row(
        //       children: [
        //         NestedTabBar("33"),
        //         GestureDetector(
        //           onHorizontalDragUpdate: (DragUpdateDetails details) {
        //             setState(() {
        //               final newLeftWidth = leftWidth + details.delta.dx;
        //               if (newLeftWidth >= 0 &&
        //                   newLeftWidth <= maxWidth - rightWidth) {
        //                 leftWidth = newLeftWidth;
        //               }
        //             });
        //           },
        //           child: Container(
        //             width: leftWidth,
        //             color: Colors.blue,
        //             child: Center(
        //               child: Text('Left Column'),
        //             ),
        //           ),
        //         ),
        //         GestureDetector(
        //           onHorizontalDragUpdate: (DragUpdateDetails details) {
        //             setState(() {
        //               final newMiddleWidth = middleWidth - details.delta.dx;
        //               if (newMiddleWidth >= 0 &&
        //                   newMiddleWidth <= maxWidth - leftWidth) {
        //                 middleWidth = newMiddleWidth;
        //               }
        //             });
        //           },
        //           child: Container(
        //             width: middleWidth,
        //             color: Colors.red,
        //             child: Center(
        //               child: Text('Right Column'),
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           child: Container(
        //               width: rightWidth,
        //               color: Colors.green,
        //               child: const Column(
        //                 children: [
        //
        //
        //
        //
        //                 ],
        //               )
        //           ),
        //         ),
        //       ],
        //     );
        //   },
        // ),
      ],),


    );
  }
}
