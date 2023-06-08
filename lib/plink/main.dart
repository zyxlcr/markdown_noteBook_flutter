//import 'dart:io';
//import 'dart:convert';
//import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chatp/plink/client.dart';
import 'package:chatp/plink/router.dart';
import 'package:chatp/plink/msg.dart';
import 'package:chatp/plink/datapack.dart';

//Client端
void main() async {
  IRouter router = IRouter();
  //TcpClient c = TcpClient(host: '127.0.0.1', port: 8989, irouter: router);
  //c.connect();
  List<int> headData = [0, 0, 30, 250, 33, 0, 0, 0, 9, 0, 0, 0];
  Uint8List head = Uint8List.fromList(headData);
  print(head);
  var m = Msg();
  m.setMsgId(10);
  m.setHeaderLen(33);
  m.setBodyLen(9);
  m.setHeaderWith('{"Url":"/ping","From":"","To":""}');
  m.setBodyWith("okkkk ooo");
  var data = DataPack.packMsg(m);
  print(data);
  var m2 = DataPack.unpack(data);
  print(m2.msgId);
  print(m2.headLen);
  print(m2.bodyLen);
  print(m2);
  var s = await Socket.connect("127.0.0.1", 8989);
  final transformer = utf8.decoder;
  s
      //.transform(transformer as StreamTransformer<Uint8List, dynamic>)
      .listen((event) {
    print(data);
    s.add(data);
  });
}

// send(Socket socket, data) async {
//   sleep(Duration(seconds: 3));
//   try {
//     socket.add(data);
//     await socket.flush();
//   } catch (e) {
//     print(e);
//   }
// }

// void test() async {
//   var client = await Socket.connect('8.218.209.29', 8989);
//   var helloBytes = utf8.encode("h123ello");
//   client.add(helloBytes);
//   await client.flush();

//   await for (var data in client) {
//     print("clinet:$data");
//     send(client, data);
//   }
// }
