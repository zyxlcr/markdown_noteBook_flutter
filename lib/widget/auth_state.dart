
import 'package:flutter/cupertino.dart';

class AuthStateWidget extends InheritedWidget {
  final bool isSignedIn;// = true;

  const AuthStateWidget({super.key,  required this.isSignedIn,  required Widget child}) : super(child: child);


  static AuthStateWidget? of(BuildContext context) {
    ///实际使用中，因为我们需要取到 MyInheritedWidget 实例 data 值，
    ///不能直接用 context.inheritFromWidgetOfExactType，
    ///只有在 MyInheritedWidget 的子类更新时，context.inheritFromWidgetOfExactType 才会重新构建 MyInheritedWidget，
    ///所以要使用 context.dependOnInheritedWidgetOfExactType 从实际使用意义上获取 MyInheritedWidget
    return context.dependOnInheritedWidgetOfExactType<AuthStateWidget>();
  }

  @override
  bool updateShouldNotify(AuthStateWidget oldWidget) {
    return isSignedIn != oldWidget.isSignedIn;
  }
}
