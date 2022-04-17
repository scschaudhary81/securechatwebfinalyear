//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//provider
import '../modals/chat_user.dart';
import '../providers/messages_provider.dart';
import '../providers/authentication_provider.dart';
import '../providers/conversation_screen_provider.dart';

//services
import '../services/navigation_services.dart';

//modals
import '../modals/chat.dart';
import '../modals/chat_message.dart';

//widgets
import '../widgets/top_bar_widget.dart';
import '../widgets/custom_list_view_tiles_user_group.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_rounded_image_widget.dart';

class ConverationScreen extends StatefulWidget {
  Chat chat;

  ConverationScreen({required this.chat});

  @override
  State<ConverationScreen> createState() => _ConverationScreenState();
}

class _ConverationScreenState extends State<ConverationScreen> {
  late double _height;
  late double _width;
  late AuthenticationProvider _auth;
  late GlobalKey<FormState> _formState;
  late NavigationServices _navigationServices;
  late ConversationScreenProvider _conversationScreenProvider;

  late ScrollController _messageListScrollController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _formState = GlobalKey<FormState>();
    _messageListScrollController = ScrollController();
    List<ChatUser> _recepients = widget.chat.recepients();
    _isActive = _recepients.any((_chatUser) => _chatUser.wasRecentlyActive());
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.height;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationServices = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConversationScreenProvider>(
          create: (_) => ConversationScreenProvider(
              widget.chat.uid, _auth, _messageListScrollController),
        ),
      ],
      child: _actualUi(),
    );
  }

  Widget _actualUi() {
    return Builder(builder: (BuildContext _context) {
      _conversationScreenProvider =
          _context.watch<ConversationScreenProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _height * 0.02, horizontal: 0.03),
            height: _height * .98,
            width: _width * .97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBarWidget(
                  widget.chat.title(),
                  fontSize: 25,
                  primaryWidget: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.teal,
                    onPressed: () {},
                  ),
                  secondaryWidget: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.teal,
                        onPressed: () {
                          _conversationScreenProvider.goBack();
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomRoundedImageNetworkWithStatusIndicator(
                        size: 40,
                        isActive: _isActive,
                        imagePath: widget.chat.groupImageUrl(),
                      ),
                    ],
                  ),
                ),
                _messagesListView(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_conversationScreenProvider.chatMessages != null) {
      if (_conversationScreenProvider.chatMessages!.length != 0) {
        return Container(
          height: .74 * _height,
          child: ListView.builder(
              itemCount: _conversationScreenProvider.chatMessages!.length,
              itemBuilder: (BuildContext_context, int _idx) {
                ChatMessage _message =
                    _conversationScreenProvider.chatMessages![_idx];
                bool isMyMessage = _message.senderId == _auth.user.uid;
                return CustomConversationTileWidget(
                  width: _width * .80,
                  height: _height,
                  chatMessage: _message,
                  isMyMessage: isMyMessage,
                  sender: widget.chat.members
                      .where((_user) => _user.uid == _message.senderId)
                      .first,
                );
              }),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say hi 😄",
            style: TextStyle(color: Colors.teal),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      );
    }
  }
}
