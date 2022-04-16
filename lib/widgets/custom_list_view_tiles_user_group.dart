//packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//widgets
import '../widgets/custom_rounded_image_widget.dart';

//modals
import '../modals/chat_message.dart';
import '../modals/chat_user.dart';

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
      onTap: ()=>onPress(),
      leading: CustomRoundedImageNetworkWithStatusIndicator(imagePath: imagePath,isActive: isActive,size: height*.7),
      minVerticalPadding: height*.20,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.teal, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: isTyping?Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SpinKitThreeBounce(color: Colors.teal,size: height*0.15,),
        ],):Text(subTitle,style: const TextStyle(color: Colors.teal,fontSize: 12,fontWeight: FontWeight.w400),),
    );
  }
}
