import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:chatp/plink/header.dart';
import 'package:chatp/vendor/tools.dart';

class Msg {
  var headerLen = 12;
  int msgId = 0;
  var headLen = 0;
  Uint8List head = Uint8List(0);
  var bodyLen = 0;
  Uint8List body = Uint8List(0);

  //Msg(this.headerLen, this.msgId, this.headLen, this.head, this.bodyLen,this.body);
  Msg();

  // 获取消息数据段长度
  int getBodyLen() {
    return bodyLen;
  }

  // 获取消息 ID
  int getMsgId() {
    return msgId;
  }

  // 获取消息内容
  Uint8List getBody() {
    return body;
  }

  String getBodyString() {
    return utf8.decode(body);
  }

  // 获取头部长度
  int getHeaderLen() {
    return headerLen;
  }

  // 获取头部内容
  Uint8List getHeader() {
    return head;
  }

  String getHeaderString() {
    return utf8.decode(head);
  }

  String getUrl() {
    var h = utf8.decode(head);
    return h;
  }

  // 设置消息数据段长度
  void setBodyLen(int len) {
    bodyLen = len;
  }

  // 设置消息 ID
  void setMsgId(int msgIdd) {
    msgId = msgIdd;
  }

  // 设置消息内容
  void setBody(Uint8List data) {
    body = data;
    bodyLen = data.length;
  }

  // 设置消息内容
  void setBodyWith(String data) {
    var t = Uint8List.fromList(utf8.encode(data));
    body = t;
    bodyLen = t.length;
  }

  // 设置头部长度
  void setHeaderLen(int len) {
    headerLen = len;
  }

  // 设置头部内容
  void setHeader(Uint8List data) {
    head = data;
    headLen = data.length;
  }

  void setHeaderWith(String data) {
    var t = Uint8List.fromList(utf8.encode(data));
    head = t;
    headLen = t.length;
  }
}

Msg newMsgPackageWithUrl(String url, Uint8List data) {
  final h = Header(url: url).toJsonString();
  var hb = Uint8List.fromList(utf8.encode(h));
  var m = Msg();
  m.setMsgId(Tools.generateMessageID());
  m.setHeaderLen(hb.length);
  // print("header len ${hb.length}");
  // print("header data ${data.length}");
  // print("header getMsgId ${m.getMsgId()}");
  m.setHeader(hb);
  m.setBodyLen(data.length);
  m.setBody(data);

  return m;
}
