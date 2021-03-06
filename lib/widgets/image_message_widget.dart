//providers
import '../providers/authentication_provider.dart';

//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get_it/get_it.dart';

//modals
import '../modals/chat_message.dart';

//constants
import '../constants.dart';

//services
import '../services/database_services.dart';

class ImageMessageWidget extends StatefulWidget {
  final bool isMyMessage;
  final double height;
  final double width;
  final ChatMessage message;
  final String chatId;

  ImageMessageWidget(
      {required this.message,
      required this.width,
      required this.isMyMessage,
      required this.height,
      required this.chatId});

  @override
  State<ImageMessageWidget> createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends State<ImageMessageWidget> {
  late DataBaseServices _db;

  String _userName = "User";
  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    DecorationImage _image = DecorationImage(
      image: NetworkImage(
        widget.message.content,
      ),
      fit: BoxFit.cover,
    );
    _db = GetIt.instance.get<DataBaseServices>();
    _db.getUserFromUid(widget.message.senderId).then((_value) {
      if (!mounted) return;
      setState(() {
        _userName = _value;
      });
    });
    return InkWell(
      onLongPress: () {
        if (_auth.user.uid != widget.message.senderId) return;
        print("called");
        _db.deleteMessage(
            widget.chatId,
            widget.message.content,
            widget.message.type == MessageType.TEXT ? "text" : "image",
            widget.message.senderId,
            widget.message.sentTime);
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.width * 0.01,
              vertical: widget.height * 0.018,
            ),
            decoration: BoxDecoration(
              borderRadius: widget.isMyMessage
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              gradient: LinearGradient(
                colors: widget.isMyMessage ? blueColorScheme : greyColorScheme,
                stops: const [0.30, 0.80],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: _image,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: widget.height,
            width: widget.width,
            padding: EdgeInsets.only(
                top: widget.height * .06,
                bottom: widget.height * .01,
                left: widget.width * .05,
                right: widget.width * .05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isMyMessage
                    ? const Text(
                        "You",
                        style: TextStyle(
                            color: secondaryMessageColor, fontSize: 12),
                      )
                    : Text(
                        _userName,
                        style: const TextStyle(
                            color: secondaryMessageColor, fontSize: 12),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(),
                    Text(
                      timeago.format(widget.message.sentTime),
                      style: const TextStyle(
                          color: secondaryMessageColor, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
