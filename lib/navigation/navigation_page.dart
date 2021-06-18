
import 'package:corona_live/Authentication/authentication_class.dart';
import 'package:corona_live/Authentication/login.dart';
import 'package:corona_live/constants/loadingWidget.dart';
import 'package:corona_live/helper/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cases_deaths_page.dart';
import 'vaccine_page.dart';

class NavigationPage extends StatefulWidget {
  final String username;
  final String pageName;
  const NavigationPage({Key key, this.username, this.pageName}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isLoading = false;
  AuthDatabase authDatabase = AuthDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0.0,
        actions: [

          FlatButton.icon(
              onPressed: ()async{
                setState(() {
                  isLoading = true;
                });
                await authDatabase.signOut();
                Fluttertoast.showToast(msg: "Logout Successful");
                PreferenceHelper.setUserLoggedInPreference(logPref: false);
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));

              },
              icon: Icon(Icons.logout, color: Colors.white,),
              label: Text("Sign Out", style: TextStyle(color: Colors.white),))
        ],
      ),
      body: isLoading == true ? GeneralLoading(): Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Row(
                      children: [
                        Icon(Icons.coronavirus_outlined, size: 25, color: Colors.white,),
                        SizedBox(width: 30,),
                        Text("Cases/Deaths", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CasesDeathsPage(username: widget.username,)));
                    },
                  ),
                ),

                SizedBox(height: 5,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Row(
                      children: [
                        Icon(Icons.local_hospital, size: 25, color: Colors.white,),
                        SizedBox(width: 30,),
                        Text("Vaccine", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VaccinePage(username: widget.username,)));
                    },
                  ),
                ),

              ],
            ),

            Spacer(),

            Container(
              child: Column(
                children: [
                  Text("welcome ${widget.username}", style: TextStyle(fontSize: 18, color: Colors.grey.shade500),),
                  Text("Previous: ${widget.pageName}", style: TextStyle(color: Colors.grey.shade600, fontSize: 19, fontWeight: FontWeight.w500),),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 3),

          ],
        ),
      ),
    );
  }
}
