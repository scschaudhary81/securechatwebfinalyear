//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//provider
import '../providers/authentication_provider.dart';
import '../providers/messages_provider.dart';

//widgets
import '../widgets/top_bar_widget.dart';
import '../widgets/custom_list_view_tiles_user_group.dart';

//modals
import '../modals/chat.dart';
import '../modals/chat_user.dart';

//services
import '../services/navigation_services.dart';

//screens
import '../modals/chat_message.dart';
import '../screens/conversation_screen.dart';

//constants
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late double _height;
  late double _width;
  late MessagesProvider _messagesProvider;
  late AuthenticationProvider _auth;
  late NavigationServices _navigationServices;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _navigationServices = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MessagesProvider>(
          create: (_) => MessagesProvider(_auth),
        ),
      ],
      child: _actualUi(),
    );
  }

  Widget _actualUi() {
    return Builder(builder: (BuildContext _context) {
      _messagesProvider = _context.watch<MessagesProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: _height * 0.02, horizontal: _width * 0.03),
        height: _height * .98,
        width: _width * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [TopBarWidget("Chats"), _messagesList()],
        ),
      );
    });
  }

  Widget _messagesList() {
    List<Chat>? _chats = _messagesProvider.chats;
    print(_chats);
    return Expanded(
      child: () {
        if (_chats != null) {
          if (_chats.isEmpty) {
            return const Center(
              child: Text(
                "No Chats Found",
                style: TextStyle(color: appMainColor),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (ctx, idx) {
                  return _messageTile(_chats[idx]);
                });
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: loadingColor,
            ),
          );
        }
      }(),
    );
  }

  Widget _messageTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive =
        _recepients.any((_chatUser) => _chatUser.wasRecentlyActive());
    String _subTitle = "No Messages";
    if (_chat.messages.isNotEmpty) {
      _subTitle = _chat.messages.first.type == MessageType.TEXT
          ? _chat.messages.first.content
          : "Image File";
    }
    return CustomListViewTilesChatGroup(
      height: _height * .10,
      imagePath: _chat.groupImageUrl(),
      isActive: _isActive,
      isTyping: _chat.activity,
      onPress: () {
        _navigationServices.navigateToPage(
          ConverationScreen(chat: _chat),
        );
      },
      subTitle: _subTitle,
      title: _chat.title(),
    );
  }
}
