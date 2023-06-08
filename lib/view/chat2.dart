import 'dart:convert';
import 'dart:typed_data';

import 'package:chatp/plink/client.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  String text;
  late String friendName = "friendName";
  bool isMe = true;
  ChatMessage({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Me1", style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(child: Text("Me")),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(friendName)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friendName,
                      style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ChatScreen extends StatefulWidget {
  TcpClient tcpClient;
  ChatScreen(this.tcpClient, {super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmit(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isMe: true,
    );

    widget.tcpClient.sendMsgWithUrl('/chat', text);
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              decoration: const InputDecoration.collapsed(
                  hintText: "Send a message..."),
              controller: _textController,
              onSubmitted: _handleSubmit,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmit(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              //itemBuilder: //(_, int index) => _messages[index],
              itemBuilder: (BuildContext context, int index) {
                ChatMessage message = _messages[index];
                if (message.isMe) {
                  return message;
                } else {
                  return message;
                }
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
