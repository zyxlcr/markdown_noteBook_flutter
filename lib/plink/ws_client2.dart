import 'dart:io';

import 'package:flutter/foundation.dart';

class WsClient {
  //连接 Febocket 服务器
  Future<WebSocket> webSocketFuture =
      WebSocket.connect("ws://192.168.1.8:8080");
  // WebSocket.connect 返回的是 Future<webSocket>对象
  static late WebSocket _webSocket;

  connect() {
    webSocketFuture.then((WebSocket ws) {
      _webSocket = ws;

      void onData(dynamic content) {
        print(content);
      }

      //调用 add 方法发送消息
      _webSocket.add("message");

      //！调用 listen 方法监听接收消息
      _webSocket.listen(onData, onDone: () {
        if (kDebugMode) {
          print(' onDone');
        }
      }, onError: () {
        if (kDebugMode) {
          print(' onError');
        }
      }, cancelOnError: true);
    });
  }
}
