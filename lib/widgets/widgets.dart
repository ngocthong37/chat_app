import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Colors.black,
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0xFFee7b64), width: 2)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0xFFee7b64), width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0xFFee7b64), width: 2)),
);

void nextSceen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}

void nextSceenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: ((context) => page)));
}

void showSnackBar(context, colors, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(fontSize: 14),), 
    backgroundColor: colors,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK", 
      onPressed: () {}, 
      textColor: Colors.white,
    ),
  )
  );
}
