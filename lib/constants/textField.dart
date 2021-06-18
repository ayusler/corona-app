import 'package:flutter/material.dart';

InputDecoration textFieldDecoration  = InputDecoration(
  hintText: "Email",
  filled: true,
  contentPadding: EdgeInsets.all(8),
  focusColor: Colors.grey.shade300,
  fillColor: Colors.grey.shade300,
  hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
);