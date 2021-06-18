import 'package:corona_live/Authentication/register.dart';
import 'package:corona_live/Authentication/welcome_page.dart';
import 'package:corona_live/constants/button.dart';
import 'package:corona_live/constants/loadingWidget.dart';
import 'package:corona_live/constants/textField.dart';
import 'package:corona_live/helper/shared_pref.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


import 'authentication_class.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email;
  String password;
  bool hidePassword = true;
  bool isLoading = false;
  bool internetConnected = true;

  AuthDatabase authDatabase = AuthDatabase();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  // Checking internet Connection
  checkConnection() async {
    bool connect = await DataConnectionChecker().hasConnection;
    if (connect == true) {
      setState(() {
        internetConnected = true;
      });
    } else {
      setState(() {
        internetConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? GeneralLoading()
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(

            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(child: Text("Welcome to Corona Live", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)),
              ),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (emailValue) {
                  setState(() {
                    email = emailValue;
                  });
                },
                validator: (emailText) {
                  if (emailText.isEmpty) {
                    return "Enter email address";
                  } else {
                    final bool isValid =
                    EmailValidator.validate(emailText);
                    if (isValid == false) {
                      return "Enter a valid email";
                    } else {
                      return null;
                    }
                  }
                },
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                controller: emailController,
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              TextFormField(
                onChanged: (passwordValue) {
                  setState(() {
                    password = passwordValue;
                  });
                },
                validator: (passwordText) {
                  if (passwordText.isEmpty) {
                    return "Enter password";
                  } else {
                    return null;
                  }
                },
                cursorColor: Colors.black,
                controller: passwordController,
                obscureText: hidePassword,
                decoration: textFieldDecoration.copyWith(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: hidePassword != true
                            ? Colors.grey.shade900
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )),
              ),

              SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    await checkConnection();
                    if (internetConnected == false) {
                      Fluttertoast.showToast(
                          msg: "No internet connection");
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await authDatabase
                          .signInAuth(email: email, password: password)
                          .then((value) async {
                        if (value != null) {
                          QuerySnapshot querySnap =
                          await firebaseFireStore
                              .collection("users")
                              .where("id",
                              isEqualTo: FirebaseAuth
                                  .instance.currentUser.uid)
                              .get();
                          final List<DocumentSnapshot> docSnaps =
                              querySnap.docs;
                          if (docSnaps.length == 0) {
                            //===================== Checking ===================
                            setState(() {
                              isLoading = false;
                            });
                            Fluttertoast.showToast(
                                msg: "User does not exist");
                          } else {
                            PreferenceHelper.setUserLoggedInPreference(
                                logPref: true);
                            PreferenceHelper.setUserLoggedEmail(
                                email: docSnaps[0].data()["email"]);
                            PreferenceHelper.setUserLoggedGender(
                                gender: docSnaps[0].data()["gender"]);
                            PreferenceHelper.setUserLoggedUsername(
                                username: docSnaps[0].data()["username"]);
                            PreferenceHelper.setUserLoggedNumber(
                                number: docSnaps[0].data()["phoneNo"]);
                            PreferenceHelper.setUserLoggedRegDate(
                                regDate: docSnaps[0].data()["regDate"]);
                            PreferenceHelper.setUserLoggedRegTime(
                                regTime: docSnaps[0].data()["regTime"]);
                            PreferenceHelper.setUserLoggedId(
                                id: docSnaps[0].data()["id"]);

                            // On Completion
                            Fluttertoast.showToast(
                                msg: "Login Successful");
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage(username: docSnaps[0].data()["username"],)));
                            emailController.clear();
                            passwordController.clear();
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Invalid details");
                        }
                      }).catchError((error) {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Error Occurred, Try Again");
                      });
                    }
                  }
                },
                child: RegisterButton(
                  buttonName: "Sign In",
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text("Don't have an Account?")),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text(
                        "Register Here",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      )),
                ],
              ),

              SizedBox(
                height: 15,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
