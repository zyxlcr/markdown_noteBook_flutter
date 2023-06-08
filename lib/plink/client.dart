import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
//import 'dart:ffi';

//import 'package:flutter/foundation.dart';
//import 'package:flutter/foundation.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:synchronized/synchronized.dart';
import 'package:chatp/plink/datapack.dart';
import 'package:chatp/plink/header.dart';
import 'package:chatp/plink/router.dart';
import 'package:chatp/plink/msg.dart';

typedef ConnectFunction = Future<void> Function(
    IRouter irouter, String host, int port, Socket? s, int reconnect);

class TcpClient {
  String host;
  int port;
  Socket? _socket;
  Timer? _timer;
  int heartBeat = 0;
  bool isPackReaded = false;
  List<int> receiveList = [];
  List<Socket> connctions = [];

  int reconnect = 0;

  IRouter irouter;

  bool cancel = false;

  void connectLock() {
    var lock = Lock();
    //lock.synchronized(reconnecting());
    connect();
  }

  Future<void> connect() async {
    print("to connect $host $port $_socket");
    if (connctions.length > 2) {
      return;
    }
    try {
      // Connect to the server
      await Socket.connect(host, port).then((socket) {
        if (cancel) {
          socket.close();
        }
        connctions.add(socket);
        reconnect = 0;
        _socket = socket;
        socket.setOption(SocketOption.tcpNoDelay, false);

        // Listen for responses from the server
        socket.listen((Uint8List data) async {
          if (cancel) {
            socket.destroy();
            return;
          }
          //Logger.log('Received data from server: ${data}');

          // await for (Uint8List data in socket) {
          // String response = utf8.decode(data);
          // print('Received response: $response');

          ByteData headerData = ByteData.sublistView(data, 0, 12);
          var header = headerData.buffer.asUint8List();
          var msg = DataPack.unpack(header);
          // Logger.log(msg.getHeaderLen());
          // Logger.log(msg.getBodyLen());

          const decoder = Utf8Decoder();
          var result = decoder.convert(
              data, 12 + msg.headerLen, 12 + msg.headerLen + msg.bodyLen);
          //Logger.log(result);
          result = decoder.convert(data, 12, 12 + msg.headerLen);
          //Logger.log(result);
          Map<String, dynamic> headerJson = json.decode(result);
          Header h = Header.fromJson(headerJson);
          Logger.log(h.url);
          irouter.find(h.url, socket, msg);
          // }
        }, onDone: () async {
          Logger.log('onDone Socket closed');
          connctions.remove(socket);
          socket.destroy();
          _socket = null;
          await Future.delayed(const Duration(seconds: 5));
          reconnect++;
          if (reconnect < 5) {
            reconnecting();
          }
        }, onError: (error) async {
          Logger.log('Socket error: $error');
          connctions.remove(socket);
          socket.destroy();
          _socket = null;
          await Future.delayed(const Duration(seconds: 5));
          reconnect++;
          if (reconnect < 5) {
            reconnecting();
          }
        }, cancelOnError: true);
      });

      // Close the socket when done
      //_socket?.close();
    } catch (e) {
      Logger.log('Error connecting to server: $e');
      await Future.delayed(const Duration(seconds: 5));
      //_socket = null;
      reconnect++;
      if (reconnect < 5) {
        reconnecting();
      }
    }
  }

  // Future<void> connect() async {
  //   await readAsync(irouter, host, port, _socket, reconnect);
  // }

  TcpClient({required this.host, required this.port, required this.irouter});

  closeAll() async {
    connctions.forEach((element) async {});
    for (int i = 0; i < connctions.length; i++) {
      connctions[i].destroy();
      connctions.remove(connctions[i]);
    }
  }

  void close() async {
    cancel = true;
    print(_socket);
    print(connctions.length);

    if (_socket != null) {
      _socket = null;
    }

    await closeAll();

    print("close2");
    //_socket = null;
  }

  reconnecting() async {
    cancel = false;
    await connect();
  }

  void sendMsg(Msg m) async {
    if (_socket != null) {
      _socket!.add(DataPack.packMsg(m));
    }
  }

  void sendMsgWithUrl(String url, String body) async {
    Msg m = newMsgPackageWithUrl(url, Uint8List.fromList(utf8.encode(body)));
    // var data = DataPack.packMsg(m);
    // var m2 = DataPack.unpack(data);

    if (_socket != null) {
      _socket!.add(DataPack.packMsg(m));
      //_socket!.write(data);
      _socket!.flush();
    }
  }

  startHeartBeat() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (time) {
      heartBeat++;
      if (heartBeat > 40) {
        heartBeat = 0;
        //重连
        //if (host != null && port != null) {
        //connect();
        //}
      }
    });
  }

  //切片传输文件
  // fileSlice(DocumentModel docModel, int docIndex, int docCount,
  //     int uploadTotal) async {
  //   debugPrint('=============发送文档===当前第-$fileIndex---共=$uploadTotal');
  //   try {
  //     for (DocumentFileModel docFile in docModel.fileList!) {
  //       String docFilePath = docFile.localFilePath!;

  //       File file = File(docFilePath);

  //       var handle = await file.open();
  //       var current = 0;
  //       var size = file.lengthSync();
  //       var chunkSize = 4096;
  //       int chunkIndex = 0;
  //       while (current < size) {
  //         var len = size - current >= chunkSize ? chunkSize : size - current;
  //         var section = handle.readSync(len);
  //         current = current + len;
  //         // 处理数据块
  //         Map sendMap = {};
  //         chunkIndex += 1;
  //         String jsonStr = jsonEncode(sendMap);

  //         Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //         String base64Str = stringToBase64.encode(jsonStr);

  //         _socket?.add(int32BigEndianBytes(base64Str.length));
  //         _socket?.write(base64Str);
  //         // 立即发送并清空缓冲区
  //         await _socket?.flush();
  //       }

  //       await handle.close();
  //       fileIndex += 1;
  //       EasyLoading.showProgress(
  //           (fileIndex / uploadTotal) > 1 ? 1 : fileIndex / uploadTotal,
  //           status: '已发送%s个'.trArgs(['$fileIndex/$uploadTotal']));
  //       if (fileIndex >= uploadTotal) {
  //         fileIndex = 0;
  //         EasyLoading.showSuccess('成功'.tr);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('================${e.toString()}');
  //   }
  // }

  //接收到socket消息
//   onReceivedMsg(event) async {
//     receiveList = receiveList + event;
//     //当接收到的数据长度大于8读取消息头
//     if (isPackReaded) {
//       while (receiveList.length > 4) {
//         isPackReaded = false;
//         int headerLength = 4;
//         //读取消息体长度
//         int msgLength = byteToNum(receiveList.sublist(0, 4));

//         //当收到的消息超过消息头描述的消息体长度时取出消息体并解码
//         if (receiveList.length >= headerLength + msgLength) {
//           List<int> bodyList =
//               receiveList.sublist(headerLength, headerLength + msgLength);
//           String bodyStr = utf8.decode(bodyList);
//           //这里处理已经读取的Socket消息内容 进行解base64或者解密
//           await analysisStr(bodyStr);
//           //读取后删除已读取的消息
//           receiveList = receiveList.sublist(headerLength + msgLength);
//           if (receiveList.isEmpty) {
//             isPackReaded = true;
//           }
//         } else {
//           isPackReaded = true;
//           break;
//         }
//       }
//     }
//   }
}

/// 日志工具类
class Logger {
  static void log(Object? object) {
    if (true) {
      //kDebugMode
      print(object);
    }
  }

  static void logMap(Map map) {
    map.forEach((key, value) {
      print('$key: $value');
    });
  }
}

void start() async {
  try {
    Socket socket = await Socket.connect('8.218.209.29', 8989);
    Logger.log("Connected socket");
    socket.listen((List<int> event) {
      Logger.log(utf8.decode(event));
    });
  } catch (e) {
    Logger.log(e);
  }
}

class startTcp {
  //Instantiating the class with the Ip and the PortNumber
  TcpSocketConnection socketConnection =
      TcpSocketConnection("127.0.0.1", 8989); //8.218.209.29

  //starting the connection and listening to the socket asynchronously
  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }

  //receiving and sending back a custom message
  void messageReceived(String msg) {
    print("object" + msg);
    socketConnection.sendMessage("MessageIsReceived :D ");
  }

  void close() {
    socketConnection.sendMessageEOM("MESSAGE", "EOM");
  }
}
