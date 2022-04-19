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
  late StreamSubscription _keyBoardEventStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  bool? isTyping;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? chatMessages;

  String? _message;

  String get message {
    return _message!;
  }

  set message(String _value) {
    _message = _value;
  }

  ConversationScreenProvider(
      this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DataBaseServices>();
    _navigation = GetIt.instance.get<NavigationServices>();
    _media = GetIt.instance.get<MediaServices>();
    _cloudStorage = GetIt.instance.get<CloudStorageServices>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToIncomingMessages();
    _listenToKeyBoardChanges();
    _updateActivity();
  }

  @override
  void dispose() {
    _conversationScreenSubscription.cancel();
    super.dispose();
  }
  void goBack() {
    _navigation.goBack();
  }


 void _updateActivity(){
    _db.streamIsActivity(_chatId).listen((_event) {
      bool? _value = _event.get("is_activity");
      if(_value!=null){
        print(_value);
        isTyping = _value;
      }
    });
 }

  void _listenToKeyBoardChanges() {
    _keyBoardEventStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity": _event});
    });
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
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            if (_messagesListViewController.hasClients) {
              _messagesListViewController
                  .jumpTo(_messagesListViewController.position.maxScrollExtent);
            }
          });
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
        sentTime: DateTime.now().toUtc(),
        type: MessageType.TEXT,
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.returnPickedFile();
      if (_file != null) {
        String? _imageDownloadURl = await _cloudStorage
            .saveChatImageFirebaseStorage(_chatId, _auth.user.uid, _file);
        if (_imageDownloadURl != null) {
          ChatMessage _messageToSend = ChatMessage(
            senderId: _auth.user.uid,
            content: _imageDownloadURl!,
            sentTime: DateTime.now().toUtc(),
            type: MessageType.IMAGE,
          );
          _db.addMessageToChat(_chatId, _messageToSend);
        }
      }
    } catch (e) {
      print("error sending image message with error");
      print(e);
    }
  }
}
