import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper{

  static String userLoggedInPreference = "loggedIn";
  static String userLoggedInUsername = "LoggedUsername";
  static String userLoggedInEmail = "LoggedUserEmail";
  static String userLoggedInGender = "LoggedUserGender";
  static String userLoggedInNumber = "LoggedUserNumber";
  static String userLoggedInRegDate = "LoggedUserRegDate";
  static String userLoggedInRegTime = "LoggedUserRegTime";
  static String userLoggedId = "LoggedUserId";



  // Setting Preferences ===================
  static Future <bool> setUserLoggedInPreference({bool logPref})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(userLoggedInPreference, logPref);
  }

  static Future setUserLoggedUsername({String username})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInUsername, username);
  }

  static Future setUserLoggedEmail({String email})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInEmail, email);
  }

  static Future setUserLoggedGender({String gender})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInGender, gender);
  }
  static Future setUserLoggedNumber({String number})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInNumber, number);
  }

  static Future setUserLoggedRegDate({String regDate})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInRegDate, regDate);
  }
  static Future setUserLoggedRegTime({String regTime})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedInRegTime, regTime);
  }

  static Future setUserLoggedId({String id})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userLoggedId, id);
  }



// Getting preferences =================
  static Future <bool> getUserLoggedInPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userLoggedInPreference);
  }
  static Future getUserLoggedUsername()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInUsername);
  }

  static Future getUserLoggedEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInEmail);
  }

  static Future getUserLoggedGender()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInGender);
  }
  static Future getUserLoggedNumber()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInNumber);
  }

  static Future getUserLoggedRegDate()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInRegDate);
  }
  static Future getUserLoggedRegTime()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userLoggedInRegTime);
  }


}