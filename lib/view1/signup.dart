import 'dart:io';
import 'package:path/path.dart';
import 'package:finalproj/helper/helperfunction.dart';
import 'package:finalproj/services/auth.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/widget/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File _image;
  String imgUrl, userCheck = "true";
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController nameEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  bool isLoading = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image******$_image');
    });
  }

  singUp(context) async {
    userCheck =
        await DatabaseMethods().checkifExist(usernameEditingController.text);
    if (formKey.currentState.validate()) {
      setState(() {
        userCheck == "true" ? isLoading = true : isLoading = false;
      });
      if (userCheck == "true") {
        if (_image != null) {
          String fileName = basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(fileName);

          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

          imgUrl = await firebaseStorageRef.getDownloadURL();
        } else {
          imgUrl =
              "https://firebasestorage.googleapis.com/v0/b/final-54db8.appspot.com/o/profile-placeholder.jpg?alt=media&token=0fdd21bf-7d49-461b-9435-5cf9b2cf3d69";
        }
        await authService
            .signUpWithEmailAndPassword(
                emailEditingController.text, passwordEditingController.text)
            .then((result) {
          if (result != null) {
            Map<String, dynamic> userDataMap = {
              "RealName": nameEditingController.text,
              "userName": usernameEditingController.text,
              "userEmail": emailEditingController.text,
              "Displaypic": imgUrl,
              "wallpaper": "",
              "Users": [],
              "hashtags": [],
            };
            print("\n\n");
            DatabaseMethods()
                .addUserInfo(userDataMap, usernameEditingController.text);

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                usernameEditingController.text);
            HelperFunctions.saveUserEmailSharedPreference(
                emailEditingController.text);
            HelperFunctions.saveUserImageSharedPreference(imgUrl);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => homepage()));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: isLoading
            ? loader2()
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(top: 70, left: 15, bottom: 100),
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blueGrey[900],
                                child: (_image != null)
                                    ? Image.file(_image)
                                    : Image.asset(
                                        "assets/images/profile.jpg",
                                      ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.only(top: 50),
                            icon: Icon(
                              Icons.camera,
                              color: Colors.yellow[500],
                            ),
                            onPressed: () {
                              getImage();
                            },
                          )
                        ],
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Name"),
                              validator: (val) {
                                return val.isEmpty || val.length < 3
                                    ? "Enter Username 3+ characters"
                                    : null;
                              },
                            ),
                            TextFormField(
                              controller: usernameEditingController,
                              style: simpleTextStyle(),
                              decoration:
                                  textFieldInputDecoration("Copins Name"),
                              validator: (val) {
                                if (val.isEmpty || val.length < 3) {
                                  return "Enter Username 3+ characters";
                                } else if (userCheck != "true") {
                                  return "User Already exists";
                                } else
                                  return null;
                              },
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              controller: passwordEditingController,
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              style: simpleTextStyle(),
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
                          singUp(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "SignUp",
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
                                color: Colors.white),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Go To Login",
                              style: simpleTextStyle1(),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ));
  }
}
