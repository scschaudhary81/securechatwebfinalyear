import 'package:flutter/material.dart';
//constants
import '../constants.dart';
import '../constants.dart';

class CustomInputField extends StatelessWidget {
  final Function(String) onSaved;
  final String regExp;
  final String hintText;
  final bool isObscured;

  const CustomInputField({
    required this.onSaved,
    required this.hintText,
    required this.isObscured,
    required this.regExp,
  });
  @override
  Widget build(BuildContext context) {

    return Container(
      child: TextFormField(
        onSaved: (_input) => onSaved(_input!),
        cursorColor: Colors.black,
        style:const TextStyle(color: formFieldTextColor),
        obscureText: isObscured,
        validator: (_value){
           return RegExp(regExp).hasMatch(_value!) ? null : "Enter a valid value.";
        },
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: appMainColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none,),
        ),
      ),
    );
  }
}
