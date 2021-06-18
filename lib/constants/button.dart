
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final String buttonName;
  const RegisterButton({this.buttonName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 25),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(buttonName, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
    );
  }
}