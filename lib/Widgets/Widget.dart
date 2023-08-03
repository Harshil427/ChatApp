import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),

  border: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0),
  ),
  //
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0),
  ),
  //
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 195, 20, 20), width: 2.0),
  ),
  //
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 3, 96, 219), width: 2.0),
  ),
  //
);

void nextScreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        Navigator.pop(context);
      },
      textColor: Colors.white,
    ),
  ));
}
