import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona_live/Authentication/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthDatabase{
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserModel userModelFromFirebase({User user}){
    return user != null ? UserModel(userId: user.uid) : null;
  }

  // Sign in Function
  Future signInAuth({String email, String password})async{
    try{
      var signInProcess =  await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User signedInUser = signInProcess.user;
      return userModelFromFirebase(user: signedInUser);
    }catch(error){
      print(error.toString());
    }
  }

  // Register Function
  Future registerAuth({String email, String password})async{
    try{
      var registerProcess = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User registeredUser = registerProcess.user;
      return userModelFromFirebase(user: registeredUser);
    }catch(error){
      print(error.toString());
      print(error.message);
      Fluttertoast.showToast(msg: error.message);
    }
  }

  // Sign out Function
  Future signOut()async{
    try{
      return await firebaseAuth.signOut();
    }catch(error){
      print(error.toString());
    }
  }

// Store user details to firebase Function
  Future storeUserDetails({String id, Map userDetailsMap})async{
    await firebaseFireStore.collection("users").doc(id).set(userDetailsMap).catchError((e) => print(e.toString()));
  }

}
