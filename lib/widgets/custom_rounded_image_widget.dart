//packages

import 'dart:io';

//constants
import '../constants.dart';

//packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomRoundedImageWidget extends StatelessWidget {
  final double size;

  const CustomRoundedImageWidget({required this.size, required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: appMainColor,
      ),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(height: size * .1),
          const Text(
            "Click to add\nProfile picture",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          )
        ],
      )),
    );
  }
}

class CustomRoundedImageFileWidget extends StatelessWidget {
  final double size;
  final PlatformFile file;

  const CustomRoundedImageFileWidget(
      {required Key key, required this.file, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: appMainColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size * 1.2),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(size),
          ),
          color: appMainColor,
          image: DecorationImage(
            // for webpage uncomment the uncomment the under given
            image: Image.memory(file!.bytes!).image,
            //image: Image.file(File(file!.path!)).image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CustomRoundedImageNetworkWithStatusIndicator extends StatelessWidget {
  final bool isActive;
  final String imagePath;
  final double size;

  CustomRoundedImageNetworkWithStatusIndicator({
    required this.imagePath,
    required this.size,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(size),
            ),
            color: Colors.blueGrey,
            image: DecorationImage(
              image: NetworkImage(imagePath,),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size * 0.20,
          width: size * 0.20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        ),
      ],
    );
  }
}

class CustomRoundedImageFileWidgetForSettingPage extends StatelessWidget {
  final String imageURl;
  final double size;

  CustomRoundedImageFileWidgetForSettingPage({
    required this.size,
    required this.imageURl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: appMainColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size * 1.2),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(size),
          ),
          color: appMainColor,
          image: DecorationImage(
            // for webpage uncomment the uncomment the under given
            //image: Image.memory(file!.bytes!).image,
            image: NetworkImage(imageURl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
