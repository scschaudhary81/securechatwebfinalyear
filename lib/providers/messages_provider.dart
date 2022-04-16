import 'dart:async';

//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//services
import '../services/database_services.dart';

//providers
import '../providers/authentication_provider.dart';

//model
import '../modals/chat.dart';
import '../modals/chat_user.dart';
import '../modals/chat_message.dart';

class MessagesProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DataBaseServices _db;
  List<Chat>? chats;
  late StreamSubscription _messageStream;

  MessagesProvider(this._auth) {
    _db = GetIt.instance.get<DataBaseServices>();
    getMessages();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  void getMessages() async {
    try {
      _messageStream =
          _db.getChatForUsers(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(_snapshot.docs.map((_document) async {
          Map<String, dynamic> _messageData =
              _document.data() as Map<String, dynamic>;
          //get chat users
          List<ChatUser>_members = [];
          for(var u_id in _messageData["members"]){
            DocumentSnapshot _userSnapshot = await _db.getUser(u_id);
            Map<String,dynamic>_userDataMap = _userSnapshot.data() as Map<String,dynamic>;
            _userDataMap["uid"] = _userSnapshot.id;
            _members.add(ChatUser.fromJSON(_userDataMap));
          }
          //get last Message form chat
          List<ChatMessage>_messages=[];
          QuerySnapshot _lastChatMessage =  await _db.getLastMessage(_document.id);
          if(_lastChatMessage.docs.isNotEmpty){
                Map<String,dynamic>_messageData = _lastChatMessage.docs.first.data() as Map<String,dynamic>;
                ChatMessage _message = ChatMessage.fromJSON(_messageData);
                _messages.add(_message);
          }
          return Chat(
            uid: _document.id,
            currentUserUid: _auth.user.uid,
            activity: _messageData["is_activity"],
            group: _messageData["is_group"],
            members: _members,
            messages: _messages,
          );
        }).toList(),);
        notifyListeners();
      });
    } catch (e) {
      print("Error getting messages");
      print(e);
    }
  }
}
