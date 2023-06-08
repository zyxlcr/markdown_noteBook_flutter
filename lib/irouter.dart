import 'package:chatp/plink/router.dart';
import 'package:chatp/widget/login_info.dart';

void addAllRouter(IRouter r, LoginInfo loginInfo) {
  r.addRoute("/ping", (s, m, vars) {
    //s.write("pong");
    print("get ping");
  });

  r.addRoute("/ping/ack", (s, m, vars) {
    //s.write("pong");
    print("ack");
    Map<String, dynamic> obj = {"url": "/ping/ack"};
    loginInfo.setTcpInfo(obj);
  });

  r.addRoute("/chat", (s, m, vars) {
    //s.write("pong");
    //print("3333");
  });

  r.addRoute("/chat/ack", (s, m, vars) {
    //s.write("pong");
    //print("3333");
  });
}
