import 'package:flutter/material.dart';

//packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:get_it/get_it.dart';

//modals
import '../modals/chat_message.dart';

//constants
import '../constants.dart';

//services
import '../services/database_services.dart';

class TextMessageWidget extends StatefulWidget {
  final bool isMyMessage;
  final double height;
  final double width;
  final ChatMessage message;
  final String chatId;

  TextMessageWidget({
    required this.message,
    required this.width,
    required this.isMyMessage,
    required this.height,
    required this.chatId,
  });

  @override
  State<TextMessageWidget> createState() => _TextMessageWidgetState();
}

class _TextMessageWidgetState extends State<TextMessageWidget> {
  late DataBaseServices _db;

  String _userName = "User";

  @override
  Widget build(BuildContext context) {
    _db = GetIt.instance.get<DataBaseServices>();
    _db.getUserFromUid(widget.message.senderId).then((_value) {
      if (!mounted) return;
      setState(() {
        _userName = _value;
      });
    });
    return InkWell(
      onLongPress: () {
        print("called");
        _db.deleteMessage(
            widget.chatId,
            widget.message.content,
            widget.message.type == MessageType.TEXT ? "text" : "image",
            widget.message.senderId,
            widget.message.sentTime);
      },
      child: Container(
        height: widget.height + (widget.message.content.length / 10 * 8.0),
        width: widget.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
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
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.height * 0.10,
            ),
            widget.isMyMessage
                ? const Text(
                    "You",
                    style: TextStyle(color: secondaryMessageColor, fontSize: 8),
                  )
                : Text(
                    _userName,
                    style: const TextStyle(
                        color: secondaryMessageColor, fontSize: 8),
                  ),
            Text(
              widget.message.content,
              style: const TextStyle(color: messageColor, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(),
                Text(
                  timeago.format(widget.message.sentTime),
                  style: const TextStyle(
                      color: secondaryMessageColor, fontSize: 8),
                ),
              ],
            ),
            SizedBox(
              height: widget.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
