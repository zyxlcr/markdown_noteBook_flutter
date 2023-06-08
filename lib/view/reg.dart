import 'package:chatp/widget/login_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chatp/plink/client.dart';
import 'package:provider/provider.dart';

import '../store/local.dart';

class RegScreen extends StatefulWidget {
  TcpClient tcpClient;
  RegScreen(this.tcpClient, {super.key});
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  int _counter = 0;
  int _tapCounter = 0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    if (_tapCounter < 4) {
      _tapCounter++;
    } else {
      _tapCounter = 0;
      print("go");
      context.read<LoginInfo>().setting(true);
      //context.go('/setting');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
                child: GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 150,
                height: 150,
                //onTap: _incrementCounter,
                //'${_counter}',
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    //'${_counter}',
                    image: AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                LocalStore.saveId(555);
                context.read<LoginInfo>().reg(false);
                context.read<LoginInfo>().login("userName");
                //context.go('/');
              },
              child: Text('注册'),
            ),
          ],
        ),
      ),
    );
  }
}
