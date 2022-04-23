//packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

//constants
import '../constants.dart';

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
    _width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationServices = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConversationScreenProvider>(
          create: (_) => ConversationScreenProvider(
            widget.chat.uid,
            _auth,
            _messageListScrollController,
          ),
        ),
      ],
      child: _actualUi(),
    );
  }

  Widget _actualUi() {
    return Builder(builder: (BuildContext _context) {
      _conversationScreenProvider =
          _context.watch<ConversationScreenProvider>();
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        includeSemantics: true,
        onKey: (_event){
                if(_event.isKeyPressed(LogicalKeyboardKey.enter)||_event.isKeyPressed(LogicalKeyboardKey.numpadEnter)){
                  _conversationScreenProvider.isTyping = false;
                  _conversationScreenProvider.listenToKeyBoardChanges();
                  print("sssss");
                  _conversationScreenProvider.sendImageMessage();
                }else{
                  print("s");
                  _conversationScreenProvider.isTyping = true;
                  _conversationScreenProvider.listenToKeyBoardChanges();
                }

        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: _height * 0.01, horizontal: 0.03),
              height: _height * .99,
              width: _width * .97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 TopBarWidget(
                      widget.chat.title(),
                      fontSize: 25,
                      primaryWidget: IconButton(
                        icon: const Icon(Icons.delete),
                        color: topBarColor,
                        onPressed: () {
                          _conversationScreenProvider.deleteChat();
                        },
                      ),
                      secondaryWidget: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: topBarColor,
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
                  _isTypingWidget(),
                  _sendMessageForm(),
                ],
              ),
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
          padding: EdgeInsets.symmetric(horizontal: _width * 0.01),
          height: .65 * _height,
          child: ListView.builder(
              controller: _messageListScrollController,
              itemCount: _conversationScreenProvider.chatMessages!.length,
              itemBuilder: (BuildContext _context, int _idx) {
                ChatMessage _message =
                    _conversationScreenProvider.chatMessages![_idx];
                bool isMyMessage = _message.senderId == _auth.user.uid;
                return CustomConversationTileWidget(
                  chatId: widget.chat.uid,
                  width: _width,
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
        return  Container(
          padding: EdgeInsets.symmetric(horizontal: _width * 0.01),
          height: .65 * _height,
          alignment: Alignment.center,
          child: const Text(
            "Be the first to say hi 😄",
            style: TextStyle(color: textColor),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: loadingColor,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _height * 0.10,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _width * .03,
        vertical: _height * 0.03,
      ),
      child: Form(
        key: _formState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _imageMessagePickerButton(),
            _sendMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return Container(
      width: _width * 0.70,
      height: _height * .08,
      child: CustomInputField(
        onSaved: (_value) {
          _conversationScreenProvider.message = _value;
        },
        hintText: "Enter any message",
        isObscured: false,
        regExp: r"^(?!\s*$).+",
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _height * .05;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: appMainColor,
        onPressed: () {
          _conversationScreenProvider.isTyping = false;
          _conversationScreenProvider.listenToKeyBoardChanges();
          _formState.currentState!.save();
          if (_conversationScreenProvider.message != null) {
            if (_conversationScreenProvider.message != "" &&
                validateStringInput(_conversationScreenProvider.message) !=
                    "" &&
                _conversationScreenProvider.message.length < 70) {
              _conversationScreenProvider.sentTextMessage();
              _formState.currentState!.reset();
            } else {
              _formState.currentState!.reset();
            }
          }
        },
        child: const Icon(Icons.send_sharp, color: sendButtonColor),
      ),
    );
  }

  Widget _imageMessagePickerButton() {
    double _size = _height * 0.05;
    return SizedBox(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        onPressed: () {
          _conversationScreenProvider.sendImageMessage();
        },
        backgroundColor: appMainColor,
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }

  String validateStringInput(String s) {
    while (s.length > 0 && s[0] == " " && s[s.length - 1] == " ") s = s.trim();
    return s;
  }

  Widget _isTypingWidget() {
    return _conversationScreenProvider.isTyping != null &&
            _conversationScreenProvider.isTyping!
        ? Container(
      height: _height*0.03,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: _width*.05,
                ),
                const Text("Typing",style: TextStyle(color: appMainColor),),
                SizedBox(
                  width: _width*.02,
                ),
                const SpinKitThreeBounce(
                  color: loadingColor,
                  size: 15,
                ),
              ],
            ),
        )
        : Container();
  }
  @override
  void dispose() {
    _conversationScreenProvider.isTyping = false;
    _conversationScreenProvider.listenToKeyBoardChanges();
    super.dispose();
  }
}
