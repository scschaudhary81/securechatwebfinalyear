import 'dart:async';

//packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//services
import '../services/database_services.dart';
import '../services/media_services.dart';
import '../services/cloud_storage_services.dart';
import '../services/navigation_services.dart';

//providers
import '../providers/authentication_provider.dart';

//modals
import '../modals/chat_message.dart';

class ConversationScreenProvider extends ChangeNotifier {
  late DataBaseServices _db;
  late CloudStorageServices _cloudStorage;
  late MediaServices _media;
  late NavigationServices _navigation;
  late StreamSubscription _conversationScreenSubscription;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? chatMessages;

  String? _message;

  String get message {
    return message;
  }

  ConversationScreenProvider(
      this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DataBaseServices>();
    _navigation = GetIt.instance.get<NavigationServices>();
    _media = GetIt.instance.get<MediaServices>();
    _cloudStorage = GetIt.instance.get<CloudStorageServices>();
    listenToIncomingMessages();
  }

  @override
  void dispose() {
    _conversationScreenSubscription.cancel();
    super.dispose();
  }

  void goBack() {
    _navigation.goBack();
  }

  void listenToIncomingMessages() {
    try {
      _conversationScreenSubscription =
          _db.streamMessagesFoChat(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_d) {
              Map<String, dynamic> _data = _d.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_data);
            },
          ).toList();
          chatMessages = _messages;
          notifyListeners();
          //add scroll to bottom call
        },
      );
    } catch (e) {
      print("error getting messages");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void sentTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        senderId: _auth.user.uid,
        content: _message!,
        sentTime: DateTime.now(),
        type: MessageType.TEXT,
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }
  void sendImageMessage() async{
    try{
      PlatformFile? _file  = await _media.returnPickedFile();
      if(_file != null){
        String? _imageDownloadURl = await _cloudStorage.saveChatImageFirebaseStorage(_chatId,_auth.user.uid, _file);
        if(_imageDownloadURl!=null){
          ChatMessage _messageToSend = ChatMessage(
            senderId: _auth.user.uid,
            content: _imageDownloadURl!,
            sentTime: DateTime.now(),
            type: MessageType.IMAGE,
          );
          _db.addMessageToChat(_chatId, _messageToSend);
        }
      }
    }catch(e){
      print("error sending image message with error");
      print(e);
    }
  }
}
