import 'package:chatp/plink/client.dart';
import 'package:chatp/vendor/tools.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter/material.dart';

class LocalStore {
  //final Localstore _localstore = Localstore();

  static final db = Localstore.instance;

  static void init() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static void saveId(int ids) {
    // gets new id
    //final id = db.collection('todos').doc().id;

    // save the item
    db.collection('todos').doc("user").set({
      'userId': ids,
    });
  }

  static void saveConfig(String con) {
    // gets new id
    //final id = db.collection('todos').doc().id;

    // save the item
    db.collection('todos').doc("config").set({
      'hostPort': con,
    });
  }

  static Future<Map<String, dynamic>?> getId() async {
    final data = await db.collection('todos').doc("user").get();
    return data;
  }

  static Future<Map<String, dynamic>?> getConfig() async {
    var value =
        await db.collection('todos').doc("config").get(); //.then((value) {
    //final data = value;
    //print(value);
    //print(value?['hostPort']);
    return value;
    //});
  }

  static TcpClient getTcpClientConfig(TcpClient client) {
    var hostPort = "tcp://127.0.0.1:8081";
    LocalStore.getConfig().then((value) {
      //print(value!['hostPort']);
      if (value != null) {
        hostPort = value!['hostPort'];
        var netType = Tools.getHostPort(hostPort);
        if (netType?.scheme == "tcp") {
          client.host = netType?.host ?? "127.0.0.1";
          client.port = netType?.port ?? 8080;
        }
      }
    });
    return client;
  }

  static void delId() {
    db.collection('todos').doc("user").delete();
  }

  static Future<Map<String, dynamic>?> getAll(String collection) async {
    final items = await db.collection(collection).get();
    return items;
  }

  static Stream<Map<String, dynamic>> getStream(String collection) {
    final stream = db.collection('todos').stream;
    return stream;
  }
}
