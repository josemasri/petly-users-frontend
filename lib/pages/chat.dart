import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttersecretchat/api/auth_api.dart';
import 'package:fluttersecretchat/models/message.dart';
import 'package:fluttersecretchat/providers/chat_provider.dart';
import 'package:fluttersecretchat/providers/me.dart';
import 'package:fluttersecretchat/utils/dialogs.dart';
import 'package:fluttersecretchat/utils/session.dart';
import 'package:fluttersecretchat/utils/socket_client.dart';
import 'package:fluttersecretchat/widgets/chat.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatKey = GlobalKey<ChatState>();
  Me _me;
  ChatProvider _chat;
  final _authAPI = AuthAPI();
  final _socketClient = SocketClient();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    _socketClient.disconnect();
    super.dispose();
  }

  _connectSocket() async {
    final token = await _authAPI.getAccessToken();
    await _socketClient.connect(token);
    _socketClient.onNewMessage = (data) {
      final message = Message(
        id: data['from']['id'],
        message: data['message'],
        email: data['from']['email'],
        petId: data['from']['petId'],
        createdAt: DateTime.now(),
      );
      _chat.addMessage(message);
      _chatKey.currentState.checkUnread();
    };

    _socketClient.onConnected = (data) {
      final users = Map<String, dynamic>.from(data['connectedUsers']);
      _chat.counter = users.length;
    };

    _socketClient.onJoined = (data) {
      _chat.counter++;
    };

    _socketClient.onDisconnected = (data) {
      if (_chat.counter > 0) {
        _chat.counter--;
      }
    };
  }

  _onExit() {
    Dialogs.confirm(context, title: "CONFIRM", message: "Are you sure?",
        onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () async {
      Navigator.pop(context);
      Session session = Session();
      await session.clear();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
    });
  }

  _sendMessage(String text, int petId) {
    Message message = Message(
      id: _me.data.id,
      petId: petId,
      email: _me.data.email,
      message: text,
      type: 'text',
      createdAt: DateTime.now(),
    );

    _socketClient.emit('send', text);

    _chat.addMessage(message);
    _chatKey.currentState?.goToEnd();
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);
    _chat = ChatProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(
          "Connected (${_chat.counter})",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (String value) {
              if (value == "exit") {
                _onExit();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "share",
                child: Text("Share App"),
              ),
              PopupMenuItem(
                value: "exit",
                child: Text("Exit App"),
              )
            ],
          )
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Chat(
          _me.data.id,
          key: _chatKey,
          onSend: _sendMessage,
          messages: _chat.messages,
        ),
      ),
    );
  }
}
