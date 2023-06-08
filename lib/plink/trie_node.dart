import 'dart:io';
import 'package:chatp/plink/msg.dart';

typedef SocketFunction = void Function(Socket s, Msg m);
typedef SFmap = Map<String, SocketFunction>;
typedef SfMList = List<SFmap>;

class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
  SocketFunction? myMethod;

  TrieNode() {
    children = {};
    isEndOfWord = false;
  }
}

class Trie {
  TrieNode root = TrieNode();

  Trie() {
    root = TrieNode();
  }

  void insert(String word, SocketFunction sf) {
    TrieNode node = root;

    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!node.children.containsKey(char)) {
        node.children[char] = TrieNode();
      }
      node = node.children[char]!;
    }

    node.isEndOfWord = true;
    node.myMethod = sf;
    //if (node.myMethod != null) {
    //node.myMethod!(s,m); // 调用每个节点上的方法
    //}
  }

  bool search(String word) {
    TrieNode node = root;

    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!node.children.containsKey(char)) {
        return false;
      }
      node = node.children[char]!;
    }

    return node.isEndOfWord;
  }

  bool startsWith(String prefix) {
    TrieNode node = root;

    for (int i = 0; i < prefix.length; i++) {
      String char = prefix[i];
      if (!node.children.containsKey(char)) {
        return false;
      }
      node = node.children[char]!;
    }

    return true;
  }
}
