import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/helper/helperfunction.dart';
import 'package:finalproj/services/auth.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/widget/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);
          HelperFunctions.saveUserImageSharedPreference(
              userInfoSnapshot.documents[0].data["Displaypic"]);

          Constants.following = userInfoSnapshot.documents[0].data["Users"];
          Constants.hashtags = userInfoSnapshot.documents[0].data["hashtags"];

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homepage()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? loader2()
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.deepOrange[50],
                  image: DecorationImage(
                    image: AssetImage("assets/images/Login2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Column(
                    children: [
                      Spacer(),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please Enter Correct Email";
                              },
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              style: simpleTextStyle(),
                              controller: passwordEditingController,
                              decoration: textFieldInputDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign In",
                            style: simpleTextStyle1(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Go To Signup",
                            style: simpleTextStyle1(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
