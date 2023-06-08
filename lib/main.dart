import 'package:chatp/widget/login_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chatp/plink/client.dart';
import 'package:chatp/plink/router.dart';
import 'package:chatp/store/local.dart';
import 'package:chatp/irouter.dart';
import 'package:chatp/gorouter.dart';
import 'package:provider/provider.dart';

var r = IRouter();

TcpClient client = TcpClient(host: '127.0.0.1', port: 8989, irouter: r);

late final GoRouter _router;

void main() async {
  LocalStore.init();
  final LoginInfo _loginInfo = LoginInfo();

  addAllRouter(r, _loginInfo);
  LocalStore.getTcpClientConfig(client);
  client.connectLock();

  _router = addAll(client, _loginInfo);

  //LocalStore.init();
  //start();
  //startTcp t = startTcp();
  //t.startConnection();
  runApp(
      // MaterialApp(home: LoginScreen(client))); //LoginScreen//ChatScreen(client)
      ChangeNotifierProvider(
          create: (context) => _loginInfo,
          child: MaterialApp.router(
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true),
            builder: EasyLoading.init(),
          )));
}
