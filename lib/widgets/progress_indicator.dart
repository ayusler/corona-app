import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation <Color> (Colors.deepPurple,), backgroundColor: Colors.white,),

          SizedBox(height: 10,),

          Text("please wait, Fetching Data from Server"),

        ],
      ),
    ));
  }
}
