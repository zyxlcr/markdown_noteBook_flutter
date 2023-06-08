import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 添加Widgets绑定观察器
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除Widgets绑定观察器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // 当屏幕尺寸发生变化时调用
    super.didChangeMetrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用程序的生命周期状态发生变化时被调用
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeAccessibilityFeatures() {
    // 当可访问性功能发生变化时被调用
    super.didChangeAccessibilityFeatures();
  }

  @override
  void didChangeLocales(List<Locale>? locale) {
    // 当用户的区域设置发生变化时被调用
    super.didChangeLocales(locale);
  }

  @override
  void didChangeTextScaleFactor() {
    // 当文本缩放因子发生变化时被调用
    super.didChangeTextScaleFactor();
  }

  @override
  void didHaveMemoryPressure() {
    // 当系统内存不足时被调用
    super.didHaveMemoryPressure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('响应键盘快捷键'),
      ),
      body: Center(
        child: Text('按下 Command + S 触发保存操作'),
      ),
    );
  }

  @override
  Future<bool> didPopRoute() async {
    // 当用户从导航返回栈中弹出最上面的路由时被调用
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) async {
    // 当一个新的路由被推到导航堆栈上时被调用
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    // 当一个新的路由信息被推到导航堆栈上时被调用
    return super.didPushRouteInformation(routeInformation);
  }

  // @override
  // Future<bool> didPopRouteInformation() async {
  //   // 当用户从导航返回栈中弹出最上面的路由信息时被调用
  //   //return super.didPopRouteInformation();
  // }

  @override
  void didChangePlatformBrightness() {
    // 当平台的亮度模式发生变化时被调用
    super.didChangePlatformBrightness();
  }

  // @override
  // void didChangeLocales(Locale? locale) {
  //   // 当应用程序的语言环境发生变化时被调用
  //   super.didChangeLocales(locale);
  // }

  // @override
  // Future<bool> didPushModalRoute(Route<dynamic> route) async {
  //   // 当一个新的模态路由被推到导航堆栈上时被调用
  //   return super.didPushModalRoute(route);
  // }

  // @override
  // Future<bool> didPopModalRoute(Route<dynamic> route) async {
  //   // 当用户从导航栈中弹出最上面的模态路由时被调用
  //   return super.didPopModalRoute(route);
  // }

  // @override
  // Future<bool> didStopUserGesture() async {
  //   // 当用户收手势操作时被调用
  //   return super.didStopUserGesture();
  // }

//   @override
//   Future<bool> didStartUserGesture() async {
// // 当用户开始手势操作时被调用
//     return super.didStartUserGesture();
//   }

  @override
  void didChangeTextEditingValue(TextEditingValue value) {
// 当文本编辑器的值发生变化时被调用
    if (value.text.toLowerCase() == 'save' &&
        value.selection.baseOffset == value.selection.extentOffset) {
// 判断输入的文本是否为'save'，且光标没有选中文本
// 如果满足条件，则触发保存操作
      _save();
    }
    //super.didChangeTextEditingValue(value);
  }

  void _save() {
// 执行保存操作的代码
    print('执行保存操作');
  }
}
