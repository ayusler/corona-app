import 'package:flutter/material.dart';



class GeneralLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width:  MediaQuery.of(context).size.width / 1.3,
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation <Color> (Colors.deepPurple,), backgroundColor: Colors.white,),
            SizedBox(height: 12,),
            Center(child: Text("Please Wait..", style: TextStyle(color: Colors.black, fontSize: 17),)),
          ],
        )),
      ),
    );
  }
}
