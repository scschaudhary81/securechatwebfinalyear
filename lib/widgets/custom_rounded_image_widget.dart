//packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomRoundedImageWidget extends StatelessWidget {
  final String imagePath;
  final double size;

  const CustomRoundedImageWidget(
      {required this.size, required this.imagePath, required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: Colors.teal,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imagePath),
        ),
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
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: Colors.teal,
        image:
            DecorationImage(image: AssetImage(file.path!), fit: BoxFit.cover),
      ),
    );
  }
}
