import 'package:chatp/widget/list_iteam.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:chatp/store/local.dart';
import 'package:chatp/store/file.dart';
import 'package:chatp/plink/client.dart';
import 'package:chatp/widget/login_info.dart';

import 'package:chatp/widget/auth_state.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);
  bool _isSignedIn = true;

  @override
  createState() {}

  @override
  Widget build(BuildContext context) {
    final LoginInfo loginInfo = context.read<LoginInfo>();
    FileProvider.getFile();
    LocalStore.getId().then((value) => {
          if (value == null)
            {
              //context.go('/login'),
              _isSignedIn = false,
              Logger.log("value is null"),
            }
          else
            {
              Logger.logMap(value),
              _isSignedIn = true,
            }
        });

    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: const IconThemeData(color: Colors.deepPurple),
          iconTheme: const IconThemeData(color: Colors.deepPurple),
          title: const Text("Home"),
          actions: <Widget>[
            IconButton(
              onPressed: loginInfo.logout,
              tooltip: 'Logout: ${loginInfo.userName}',
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: MyList());
  }
}
