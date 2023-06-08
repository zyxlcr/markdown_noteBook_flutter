import 'dart:io';
import 'package:chatp/plink/msg.dart';

typedef HandlerFunc = void Function(Socket s, Msg m, Map<String, String> vars);

class IRouter {
  Map<String, HandlerFunc> _routes = {};

  void addRoute(String path, HandlerFunc handler) {
    _routes[path] = handler;
  }

  // void serve(HttpRequest request, HttpResponse response) {
  //   for (var k in _routes.keys) {
  //     var parts = k.split('');
  //     if (parts.length != 2) {
  //       continue;
  //     }
  //     if (request.method == parts[0]) {
  //       if (_matchPath(request.uri.path, parts[1])) {
  //         var vars = _extractVars(request.uri.path, parts[1]);
  //         _routes[k]!(response, request, vars);
  //         return;
  //       }
  //     }
  //   }
  //   response.statusCode = HttpStatus.notFound;
  //   response.close();
  // }

  void find(String path, Socket s, Msg m) {
    //print(path);
    //print(_routes);
    for (var k in _routes.keys) {
      //if (request.method == parts[0]) {
      if (_matchPath(path, k)) {
        var vars = _extractVars(path, k);
        _routes[k]!(s, m, vars);
        return;
      }
      //}
    }
  }

  bool _matchPath(String path, String pattern) {
    var pathParts = path.split('/');
    var patternParts = pattern.split('/');

    if (pathParts.length != patternParts.length) {
      return false;
    }

    for (var i = 0; i < patternParts.length; i++) {
      var part = patternParts[i];
      //print('part: $part');
      if (part != '' && part[0] == ':') {
        continue;
      }
      if (pathParts[i] != part) {
        return false;
      }
    }

    return true;
  }

  Map<String, String> _extractVars(String path, String pattern) {
    var vars = <String, String>{};

    var pathParts = path.split('/');
    var patternParts = pattern.split('/');

    for (var i = 0; i < patternParts.length; i++) {
      var part = patternParts[i];
      if (part != '' && part[0] == ':') {
        vars[part.substring(1)] = pathParts[i];
      }
    }

    return vars;
  }
}
