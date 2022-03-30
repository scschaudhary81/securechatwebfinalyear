import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  const CustomRoundedButton({
    required this.height,
    required this.name,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          onPressed();
        },
        color: Colors.teal,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            //height: 25.0,
          ),
        ),
      ),
    );
  }
}
