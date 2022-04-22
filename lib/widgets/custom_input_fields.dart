import 'package:flutter/material.dart';

//constants
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
        style: const TextStyle(color: formFieldTextColor),
        obscureText: isObscured,
        validator: (_value) {
          return RegExp(regExp).hasMatch(_value!)
              ? null
              : "Enter a valid value.";
        },
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: appMainColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class CustomSearchTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool isObscured;
  final TextEditingController controller;
  IconData? icon;

  CustomSearchTextField({
    required this.controller,
    required this.hintText,
    required this.isObscured,
    required this.onEditingComplete,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: formFieldTextColor,
      obscureText: isObscured,
      style: const TextStyle(color: formFieldTextColor),
      decoration: InputDecoration(
        fillColor: formFillColorSearch,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
        hintText: hintText,
        hintStyle: const TextStyle(color: appMainColor),
        prefixIcon: Icon(icon,color: appMainColor,),
      ),
    );
  }
}
