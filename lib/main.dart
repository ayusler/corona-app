import 'package:corona_live/content/vaccine_class.dart';
import 'package:corona_live/models/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Authentication/login.dart';
import 'content/cases_death_class.dart';
import 'helper/shared_pref.dart';
import 'Authentication/welcome_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  String username;
  @override
  void initState(){
    super.initState();
    setState(() {
      userIsLoggedIn = false;
    });
    getUserLogInState();
  }

  getUserLogInState()async{
    await PreferenceHelper.getUserLoggedUsername().then((value) {setState(() {
      value != null ? username = value : username = '';
    });});
    await PreferenceHelper.getUserLoggedInPreference().then((value) {
      if (value == null){
        setState(() {
          userIsLoggedIn = false;
        });
      }else{
        setState(() {
          userIsLoggedIn = value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<MyModel>(
      model: MyModel(),
      child: ScopedModel(
        model: VaccineClass(),
        child: ScopedModel<CasesDeathClass>(
          model: CasesDeathClass(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: userIsLoggedIn ? WelcomePage(username: username,) : SignIn(),
          ),
        ),
      ),
    );
  }
}
