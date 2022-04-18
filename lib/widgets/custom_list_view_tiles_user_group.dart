//packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//widgets
import '../widgets/custom_rounded_image_widget.dart';
import '../widgets/text_message_widget.dart';
import '../widgets/image_message_widget.dart';

//modals
import '../modals/chat_message.dart';
import '../modals/chat_user.dart';

//constants
import '../constants.dart';

class CustomListViewTilesChatGroup extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isTyping;
  final Function onPress;

  CustomListViewTilesChatGroup({
    required this.height,
    required this.imagePath,
    required this.isActive,
    required this.isTyping,
    required this.onPress,
    required this.subTitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onPress(),
      leading: CustomRoundedImageNetworkWithStatusIndicator(
          imagePath: imagePath, isActive: isActive, size: height * .7),
      minVerticalPadding: height * .20,
      title: Text(
        title,
        style: const TextStyle(
            color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: isTyping
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SpinKitThreeBounce(
                  color: loadingColor,
                  size: height * 0.15,
                ),
              ],
            )
          : Text(
              subTitle,
              style: const TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
    );
  }
}

class CustomConversationTileWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isMyMessage;
  final ChatMessage chatMessage;
  final ChatUser sender;
  final String chatId;

   CustomConversationTileWidget({
    required this.chatMessage,
    required this.height,
    required this.isMyMessage,
    required this.width,
    required this.sender,
     required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isMyMessage
              ? CustomRoundedImageNetworkWithStatusIndicator(
                  imagePath: sender.imageURL,
                  size: width * 0.08,
                  isActive: sender.wasRecentlyActive())
              : Container(),
          SizedBox(
            width: width * .02,
          ),
          chatMessage.type == MessageType.TEXT
              ?TextMessageWidget(message: chatMessage, width: width*.5, isMyMessage: isMyMessage, height: height*0.06,chatId:chatId)
              : ImageMessageWidget(message: chatMessage, width: width*.65, isMyMessage: isMyMessage, height: height*0.30,chatId:chatId)
        ],
      ),
    );
  }
}
