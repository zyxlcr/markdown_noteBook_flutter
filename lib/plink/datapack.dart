import 'dart:convert';
import 'dart:typed_data';

import 'package:chatp/plink/msg.dart';

class DataPack {
  static void writeUint32LE(Uint8List data, int offset, int value) {
    ByteData.view(data.buffer).setUint32(offset, value, Endian.little);
  }

  static Uint8List packMsg(Msg msg) {
    // 创建一个存放 bytes 字节的缓冲
    var dataBuff = ByteData(12 + msg.getHeaderLen() + msg.getBodyLen());
    //var data = Uint8List(12 + msg.getHeaderLen() + msg.getBodyLen());
    // 写 msgID
    dataBuff.setUint32(0, msg.getMsgId(), Endian.little);
    //writeUint32LE(data, 0, msg.getMsgId());
    //writeUint32LE(data, 4, msg.getHeaderLen());
    //writeUint32LE(data, 8, msg.getBodyLen());
    //var data2 = data.toList();
    //var body2 = utf8.encode(msg.getBody().toString());
    //var header2 = utf8.encode(msg.getHeader().toString());
    //data2.addAll(header2);
    //data2.addAll(body2);

    // var msgid = utf8.encode(msg.getMsgId().toString());
    // for (var i = 0; i < msgid.length; i++) {
    //   dataBuff.setUint8( i, msgid[i]);
    // }

    // 写 headerLen
    dataBuff.setUint32(4, msg.getHeaderLen(), Endian.little);
    // var headerLen = utf8.encode(msg.getHeaderLen().toString());
    // for (var i = 0; i < headerLen.length; i++) {
    //   dataBuff.setUint8(4+ i, headerLen[i]);
    // }

    // 写 bodyLen
    dataBuff.setUint32(8, msg.getBodyLen(), Endian.little);
    // var bodyLen = utf8.encode(msg.getBodyLen().toString());
    // for (var i = 0; i < bodyLen.length; i++) {
    //   dataBuff.setUint8(8+ i, bodyLen[i]);
    // }

    // 写 header
    var header = msg.getHeader();
    for (var i = 0; i < header.length; i++) {
      dataBuff.setUint8(12 + i, header[i]);
    }

    // 写 data 数据
    var body = msg.getBody();
    for (var i = 0; i < body.length; i++) {
      dataBuff.setUint8(12 + header.length + i, body[i]);
    }

    return dataBuff.buffer.asUint8List();
    //return Uint8List.fromList(data2);
  }

  static Msg unpack(Uint8List binaryData) {
    // 创建一个从输入二进制数据的 io.Reader
    var dataBuff = ByteData.view(binaryData.buffer);

    // 只解压 head 的信息，得到 dataLen 和 msgID
    var msg = Msg();

    // 读 msgID
    msg.setMsgId(dataBuff.getUint32(0, Endian.little));

    // 读 headerLen
    msg.setHeaderLen(dataBuff.getUint32(4, Endian.little));

    // 读 bodyLen
    msg.setBodyLen(dataBuff.getUint32(8, Endian.little));
    const decoder = Utf8Decoder();
    msg.setHeaderWith(
        decoder.convert(binaryData.toList(), 12, 12 + msg.headerLen));

    //msg.setHeader(dataBuff.getUint16(6, Endian.little));

    // 判断 dataLen 的长度是否超出我们允许的最大包长度
    // if (utils.GlobalObject.MaxPacketSize > 0 && msg.DataLen > utils.GlobalObject.MaxPacketSize) {
    // return nil, errors.New("Too large msg data recieved")
    // }

    // 这里只需要把 head 的数据拆包出来就可以了，然后再通过 head 的长度，再从 conn 读取一次数据
    return msg;
  }
}
