import 'dart:math';
import 'dart:io';
import 'package:chatp/plink/client.dart';
import 'package:chatp/plink/router.dart';
import 'package:sync/sync.dart';

class Tools {
  static final _idMutex = Mutex();
  //static int _lastID = 0;
  static const maxSequence = 0xFFFF;

  static int generateMessageID() {
    _idMutex.acquire();
    try {
      final now = (DateTime.now().microsecondsSinceEpoch ~/
              Duration.microsecondsPerMillisecond) &
          0xFFFFFFFF;

      return now << 16 & 0xFFFFFFFF;
    } finally {
      _idMutex.release();
    }
  }

  static NetType? getHostPort(String url) {
    Uri uri = Uri.parse(url);
    String scheme = uri.scheme; // 'https'
    String host = uri.host;
    int port = uri.port;
    //String path = uri.path; // '/path'
    //String query = uri.query; // 'query=string'
    // print(path);
    // print(query);

    var c = NetType(scheme, host, port);
    return c;
  }
}

class NetType {
  String scheme; // 'https'
  String host; // 'example.com'
  int port;
  NetType(this.scheme, this.host, this.port);
}
