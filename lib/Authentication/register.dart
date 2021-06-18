import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona_live/Authentication/login.dart';
import 'package:corona_live/constants/button.dart';
import 'package:corona_live/constants/loadingWidget.dart';
import 'package:corona_live/constants/textField.dart';
import 'package:corona_live/helper/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'authentication_class.dart';
import 'welcome_page.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  AuthDatabase authDatabase = AuthDatabase();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String username;
  String email;
  String password;
  String password2;
  String phoneNo;
  bool hidePassword = true;
  bool hidePassword2 = true;
  String groupValue = "Male";
  String gender = "Male";
  bool isLoading = false;
  bool internetConnected = true;


  // Check internet
  checkInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        internetConnected = true;
      });
    } else {
      setState(() {
        internetConnected = false;
      });
    }
  }

  validateEmail({String email}) {
    final bool isValid = EmailValidator.validate(email);
    if (isValid == false) {
      return "Enter a valid email";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    gender = "Male";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: MediaQuery.of(context).size.height / 8,
              ),

              // username TextField =================================
              TextFormField(
                validator: (valid) {
                  if (valid.isEmpty) {
                    return "Enter username";
                  } else {
                    if (valid.length > 10) {
                      return "maximum of ten characters is required";
                    }
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                controller: usernameController,
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Username (max of six)',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              // Email TextField =================================
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter email address";
                  } else {
                    final bool isValid = EmailValidator.validate(value);
                    if (isValid == false) {
                      return "Enter a valid email";
                    } else {
                      return null;
                    }
                  }
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                keyboardType: TextInputType.emailAddress,
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

              // Password TextField =================================
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter password";
                  } else {
                    if (value.length < 6) {
                      return "At least six characters";
                    } else {
                      if (password != password2) {
                        return "Password does not match";
                      }
                      return null;
                    }
                  }
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
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
                height: 10,
              ),

              // Confirm Password TextField=================================
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter password";
                  } else {
                    if (value.length < 6) {
                      return "At least six characters";
                    } else {
                      if (password2 != password) {
                        return "Password does not match";
                      }
                      return null;
                    }
                  }
                },
                onChanged: (value) {
                  setState(() {
                    password2 = value;
                  });
                },
                controller: passwordController2,
                obscureText: hidePassword2,
                decoration: textFieldDecoration.copyWith(
                    hintText: "Confirm Password",
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
                          hidePassword2 = !hidePassword2;
                        });
                      },
                    )),
              ),

              SizedBox(
                height: 10,
              ),

              // Phone number TextField ================================
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter phone number";
                  } else {
                    if (value.length < 10 || value.length > 15) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    phoneNo = value;
                  });
                },
                controller: phoneNoController,
                decoration: textFieldDecoration.copyWith(
                  hintText: "Phone no",
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Gender Radio Button ======================
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            Flexible(
                                child: Text(
                                  "Male",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                            Radio(
                              value: "Male",
                              focusColor: Colors.grey,
                              activeColor: Colors.deepPurple,
                              groupValue: groupValue,
                              onChanged: (newValue) {
                                toggleGender(newVal: newValue);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                              child: Text(
                                "Female",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                          Radio(
                            value: "Female",
                            focusColor: Colors.grey,
                            activeColor: Colors.deepPurple,
                            groupValue: groupValue,
                            onChanged: (newValue) {
                              toggleGender(newVal: newValue);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //Register button
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    await checkInternet();
                    if(internetConnected == false){
                      Fluttertoast.showToast(msg: "No internet connection");
                    }else{
                      setState(() {
                        isLoading = true;
                      });

                      // Getting current date and time
                      DateTime dateTime = DateTime.now();
                      var date = DateFormat("EEE, MMM d, y")
                          .format(dateTime)
                          .toString();
                      var time = DateFormat.jm().format(dateTime);

                      // Store User details to database=================================================
                      await authDatabase
                          .registerAuth(
                          email: email, password: password)
                          .then((value) async {
                        await authDatabase.storeUserDetails(
                            id: auth.currentUser.uid,
                            userDetailsMap: <String, dynamic>{
                              "id": auth.currentUser.uid,
                              "username": username,
                              "email": email,
                              "gender": gender,
                              "phoneNo": phoneNo,
                              "regDate": date,
                              "regTime": time,
                            });

                        // Saving user data locally on the device===================================
                        PreferenceHelper.setUserLoggedInPreference(
                            logPref: true);
                        PreferenceHelper.setUserLoggedEmail(
                            email: email);
                        PreferenceHelper.setUserLoggedGender(
                            gender: gender);
                        PreferenceHelper.setUserLoggedUsername(
                            username: username);
                        PreferenceHelper.setUserLoggedNumber(
                            number: phoneNo);
                        PreferenceHelper.setUserLoggedRegDate(
                            regDate: date);
                        PreferenceHelper.setUserLoggedRegTime(
                            regTime: time);
                        PreferenceHelper.setUserLoggedId(
                            id: auth.currentUser.uid);


                        await Fluttertoast.showToast(
                            msg: "Registration successful"
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage(username: username,)));

                        setState(() {
                          isLoading = false;
                        });

                      }).catchError((error) {
                        setState(() {
                          isLoading = false;
                        });

                        print(error.toString());
                      });

                    }
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: RegisterButton(
                  buttonName: "Register",
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account?"),

                  SizedBox(
                    width: 10,
                  ),

                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignIn()));
                      },
                      child: Text(
                        "Sign in Here",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                  ),

                ],
              ),

              SizedBox(height: 15,),

            ],
          ),
        ),
      ),
    );
  }

  toggleGender({newVal}) {
    setState(() {
      if (newVal == "Male") {
        gender = newVal;
        groupValue = newVal;
      } else if (newVal == "Female") {
        gender = newVal;
        groupValue = newVal;
      }
    });
  }
}
