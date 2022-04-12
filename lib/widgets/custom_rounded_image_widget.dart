//packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomRoundedImageWidget extends StatelessWidget {
  final double size;

  const CustomRoundedImageWidget(
      {required this.size, required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: Colors.teal,
      ),
      child: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Icon(Icons.add,color: Colors.white,),
            SizedBox(height: size*.1),
            const Text("Click to add\nProfile picture",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400),)
          ],
        )
      ),
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        color: Colors.teal,
        image: DecorationImage(
          // for webpage uncomment the uncomment the under given
          image: Image.file(File(file!.path!)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
