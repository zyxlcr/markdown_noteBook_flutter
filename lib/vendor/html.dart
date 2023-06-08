import 'package:chatp/model/book/book.dart';
import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/html_escape.dart';
import 'package:html/parser.dart';

class Visitor extends TreeVisitor {
  String indent = '';

  @override
  void visitText(Text node) {
    if (node.data.trim().isNotEmpty) {
      print('$indent${node.data.trim()}');
    }
  }

  @override
  void visitElement(Element node) {
    if (isVoidElement(node.localName)) {
      print('$indent<${node.localName}/>');
    } else {
      print('$indent<${node.localName}>');
      indent += '  ';
      visitChildren(node);
      indent = indent.substring(0, indent.length - 2);
      print('$indent</${node.localName}>');
    }
  }

  @override
  void visitChildren(Node node) {
    for (var child in node.nodes) {
      visit(child);
    }
  }
}

gettestList(Document document) {
  document.getElementsByClassName("entry-card").forEach((element) {
    print(element);
    element.getElementsByTagName("a").forEach((element2) {
      print(element2);
      var url = element2.attributes['href'];
      print(url);
    });
    element.getElementsByTagName("img").forEach((element2) {
      var coverUrl = element2.attributes['src'];
      print(coverUrl);
    });
    document.getElementsByClassName("entry-title").forEach((element2) {
      element2.getElementsByTagName("a").forEach((element3) {
        var name = element3.text;
        print(name);
      });
    });
  });
}

Element? getList(String rule, Document document) {
  if (rule.contains(".")) {
    var arr = rule.split(".");
    return document.getElementsByClassName(arr[1])[0];
  } else {
    var arr = rule.split("#");
    return document.getElementById(arr[1]);
  }
}

getListSub(String rule, Element element) {
  if (rule.contains("@")) {
    var arr = rule.split("@");
    arr.forEach((rule) {
      getListSubAttr(rule, element);
    });
  } else {
    getListSubAttr(rule, element);
  }
}

String? getListSubAttr(String rule, Element element) {
  var re = element.querySelector(rule);
  var arr = rule.split("@");
  if (arr.last == "text") {
    return re?.text;
  } else {
    return element.attributes[arr.last];
  }
}

List<RuleSearch> getSearch(Document document, RuleSearch rule) {
  var list = document.querySelector(rule.bookList);
  RuleSearch r = rule;
  List<RuleSearch> newList = [];
  //print(list);
  if (list != null) {
    var bookUrl = list.querySelectorAll(rule.bookUrl);
    for (int i = 0; i < bookUrl.length; i++) {
      r.bookUrl = getListSubAttr(rule.bookUrl, bookUrl[i]) ?? "";
      newList.add(r);
    }
    var name = list.querySelectorAll(rule.name);
    for (int i = 0; i < bookUrl.length; i++) {
      r.name = getListSubAttr(rule.name, name[i]) ?? "";
      newList[i].name = r.coverUrl;
    }
    var coverUrl = list.querySelectorAll(rule.coverUrl);
    for (int i = 0; i < bookUrl.length; i++) {
      print(coverUrl[i]);
      r.coverUrl = getListSubAttr(rule.coverUrl, coverUrl[i]) ?? "";
      newList[i].coverUrl = r.coverUrl;
    }
  }
  return newList;
}
