import 'package:corona_live/navigation/navigation_page.dart';
import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  final String username;
  const WelcomePage({Key key, this.username}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            child: Column(
              children: [

                //Welcome Text Container ====================
                Container(
                  color: Colors.grey.shade200,
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CORONA LIVE", style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent),),
                      Text("Hello $username!!", style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent,)),
                    ],
                  ),
                ),

                // Corona Image Container ===============================
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/images/covid.jpg", fit: BoxFit.fill,)
                  ),
                ),

              SizedBox(height: MediaQuery.of(context).size.height / 10,),

              //  Start Corona live button ========================
                RaisedButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationPage(username: username, pageName: "Welcome Page",)));
                },
                child: Text("START CORONA LIVE", style: TextStyle(color: Colors.white),),
                  color: Colors.deepPurple,
                ),

                SizedBox(height: 60,)
              ],
            ),
          ),
    );

  }
}
