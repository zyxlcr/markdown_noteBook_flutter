import 'package:chatp/store/local.dart';
import 'package:chatp/vendor/tools.dart';
import 'package:flutter/material.dart';
import 'package:chatp/plink/client.dart';
import 'package:chatp/widget/login_info.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  TcpClient tcpClient;
  late TcpClient testClient =
      TcpClient(host: "127.0.0.1", port: 8080, irouter: tcpClient.irouter);
  String hostPort = "tcp://127.0.0.1:8081";
  // SettingScreen(this.tcpClient, {super.key}){

  // }
  SettingScreen(this.tcpClient, {Key? key}) : super(key: key) {
    getConfig();
  }
  TextEditingController _myController = TextEditingController();

  getConfig() {
    LocalStore.getConfig().then((value) {
      //print(value!['hostPort']);
      if (value != null) {
        hostPort = value!['hostPort'];
        _myController.text = hostPort;
        var netType = Tools.getHostPort(_myController.text);
        if (netType?.scheme == "tcp") {
          testClient.host = netType?.host ?? "127.0.0.1";
          testClient.port = netType?.port ?? 8080;
          //widget.testClient.close();
          //widget.tcpClient.connectLock();
        }
      } else {
        _myController.text = hostPort;
        testClient.host = "127.0.0.1";
        testClient.port = 8080;
      }
    });
  }

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void dispose() {
    widget._myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //getConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getConfig();
  }

  void testIp() {
    widget.tcpClient.sendMsgWithUrl('/ping', "text");
  }

  Future<String?> show() async {
    var result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('连接成功'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, widget.hostPort);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null) {
      widget._myController.text = result;
    }
    return result;
  }

  void success(BuildContext context) {
    final LoginInfo loginInfo = context.read<LoginInfo>();
    Map<dynamic, dynamic> objMap = loginInfo.tcpInfo as Map<dynamic, dynamic>;
    if (objMap['url'] == "/ping/ack") {
      widget.getConfig();
      setState(() {
        EasyLoading.showSuccess("连接成功");
        //show();
        loginInfo.setTcpInfo({});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      success(context);
    });
    print("on");

    return Scaffold(
      appBar: AppBar(
        title: Text("配置"),
        actions: [
          IconButton(
              onPressed: () {
                // 点击保存按钮事件处理
                print("保存");
                widget.hostPort = widget._myController.text;
                LocalStore.saveConfig(widget.hostPort);
                //_myController.
                print(widget._myController.text);

                context.read<LoginInfo>().setting(false);
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                    controller: widget._myController,
                    decoration: const InputDecoration(
                      counterText: "tcp://127.0.0.1:8080",
                      labelText: '服务器地址',
                      hintText: "ws://127.0.0.1:8080",
                    )),
              ),
              TextButton(
                onPressed: () {
                  widget.hostPort = widget._myController.text;
                  LocalStore.saveConfig(widget.hostPort);
                  //widget.tcpClient.sendMsgWithUrl('/ping', "text");
                  // EasyLoading.addStatusCallback((status) {
                  //   widget._myController.text = widget.hostPort;
                  //   print("back");
                  // });
                  EasyLoading.show(status: 'loading...', dismissOnTap: true);
                  //show(status: 'loading...', dismissOnTap: true);
                  //widget.tcpClient.close();
                  var netType = Tools.getHostPort(widget._myController.text);
                  if (netType?.scheme == "tcp") {
                    widget.testClient.host = netType?.host ?? "127.0.0.1";
                    widget.testClient.port = netType?.port ?? 8989;
                    //widget.testClient.close();
                    widget.testClient.connectLock();
                    print(widget.testClient.port);
                    widget.testClient.sendMsgWithUrl("/ping", "body");
                    Future.delayed(Duration(seconds: 3), () {
                      //widget.testClient.sendMsgWithUrl("/ping", "body");
                    });
                  }
                },
                child: Text("连接"),
              ),
            ],
          )),
    );
  }
}
